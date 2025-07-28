//
//  HabitDetailViewModel.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 23/07/25.
//

import SwiftUI
import CoreData

enum HabitLogFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case week = "This Week"
    case month = "This Month"

    var id: String { rawValue }
}

struct HabitLogEntry: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let status: Status
    let count: Int
    let goal: Int

    enum Status {
        case completed, inProgress, missed
        
        var title: String {
            switch self {
            case .completed: return "Completed"
            case .inProgress: return "InProgress"
            case .missed: return "Missed"
            }
        }
        
        var iconName: String {
            switch self {
            case .completed: return "checkmark.circle.fill"
            case .inProgress: return "hourglass"
            case .missed: return "xmark.circle.fill"
            }
        }
        
        var accentColor: Color {
            switch self {
            case .completed: return .green
            case .inProgress: return .orange
            case .missed: return .red
            }
        }
    }

    var progressText: String {
        "\(count)/\(goal) completed"
    }
}


class HabitDetailViewModel: ObservableObject {
    @Published var habit: Habit
    private var viewContext: NSManagedObjectContext
    private var analytics: HabitAnalytics

    init(habit: Habit, viewContext: NSManagedObjectContext) {
        self.habit = habit
        self.viewContext = viewContext
        self.analytics = HabitAnalytics(habit: habit)
    }

    var progressRatio: CGFloat {
        guard habit.targetCount > 0 else { return 0 }
        return CGFloat(habit.currentCount) / CGFloat(habit.targetCount)
    }

    var sortedLogs: [HabitLog] {
        guard let logs = habit.logs as? Set<HabitLog> else { return [] }
        return logs.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
    }
    
    var last7DaysLogSummary: [DailyLog] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let today = calendar.startOfDay(for: Date().timezoneDate)
        let past7Days = (0..<7).compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }

        return past7Days.reversed().map { day in
            let count = sortedLogs.filter {
                guard let logDate = $0.date else { return false }
                return calendar.isDate(logDate, inSameDayAs: day)
            }.count
            return DailyLog(date: day, count: count)
        }
    }
    
    func incrementProgress() {
        guard habit.currentCount < habit.targetCount else { return }
        habit.currentCount += 1

        logCompletion(for: habit)

        save()
    }

    private func logCompletion(for habit: Habit) {
        let log = HabitLog(context: viewContext)
        log.id = UUID()
        log.date = Date().timezoneDate
        log.value = habit.currentCount
        log.habit = habit

        save()
    }

    func resetProgress() {
        habit.currentCount = 0
        save()
    }

    func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        return totalWidth * progressRatio
    }

    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save progress: \(error)")
        }
    }

    func currentStreak() -> Int {
        analytics.currentStreak()
    }

    func lastCompletedDate() -> String {
        analytics.lastCompletedDate()
    }

    func weeklyCompletionRate() -> String {
        analytics.weeklyCompletionRate()
    }
    
    func checkIfNewDayAndReset() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let now = Date().timezoneDate

        guard let lastDate = habit.lastUpdated else {
            habit.lastUpdated = now
            save()
            return
        }

        if !calendar.isDate(lastDate, inSameDayAs: now) {
            habit.currentCount = 0
            habit.lastUpdated = now
            save()
        }
    }
    
    func filteredLogs(for filter: HabitLogFilter) -> [HabitLog] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let now = Date().timezoneDate

        switch filter {
        case .all:
            return sortedLogs

        case .week:
            guard let startOfWeek = now.startOfWeek, let endOfWeek = now.endOfWeek else { return [] }
            return sortedLogs.filter {
                guard let date = $0.date else { return false }
                return date >= startOfWeek && date <= endOfWeek
            }

        case .month:
            return sortedLogs.filter {
                guard let date = $0.date else { return false }
                return calendar.isDate(date, equalTo: now, toGranularity: .month)
            }
        }
    }
    
    func logEntries(for filter: HabitLogFilter) -> [HabitLogEntry] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let today = Date().timezoneDate
        let logs = sortedLogs
        let installDate = habit.createdAt ?? Date().timezoneDate
        let habitTarget = habit.targetCount

        // Group logs by day → count completions per day
        let logsGroupedByDay: [Date: Int] = logs.reduce(into: [:]) { result, log in
            if let logDate = log.date {
                let dayStart = calendar.startOfDay(for: logDate)
                result[dayStart, default: 0] += 1
            }
        }

        var dateRange: [Date] = []

        switch filter {
        case .all:
            let days = calendar.dateComponents([.day], from: installDate.startOfDay, to: today).day ?? 0
            if days >= 0 {
                dateRange = (0...days).compactMap {
                    calendar.date(byAdding: .day, value: -$0, to: today)?.startOfDay
                }
            }

        case .week:
            if let startOfWeek = today.startOfWeek, let endOfWeek = today.endOfWeek {
                let days = calendar.dateComponents([.day], from: startOfWeek, to: endOfWeek).day ?? 0
                dateRange = (0...days).compactMap {
                    calendar.date(byAdding: .day, value: $0, to: startOfWeek)?.startOfDay
                }.filter { $0 >= installDate.startOfDay && $0 <= today.startOfDay }
            }

        case .month:
            if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) {
                let days = calendar.dateComponents([.day], from: startOfMonth, to: today).day ?? 0
                dateRange = (0...days).compactMap {
                    calendar.date(byAdding: .day, value: $0, to: startOfMonth)?.startOfDay
                }
                .filter { $0 >= installDate.startOfDay && $0 <= today.startOfDay }
            }
        }

        // Build entries
        let entries: [HabitLogEntry] = dateRange.map { date in
            let count = logsGroupedByDay[date] ?? 0

            let status: HabitLogEntry.Status
            if count >= habitTarget {
                status = .completed
            } else if calendar.isDateInToday(date) {
                status = .inProgress
            } else {
                status = .missed
            }

            return HabitLogEntry(
                date: date,
                status: status,
                count: count,
                goal: Int(habitTarget)
            )
        }

        return entries.sorted { $0.date > $1.date }
    }


    func groupedLogsByWeek(for filter: HabitLogFilter) -> [(weekStart: Date, entries: [HabitLogEntry])] {
        let logs = logEntries(for: filter)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let grouped = Dictionary(grouping: logs) { entry -> Date in
            calendar.dateInterval(of: .weekOfYear, for: entry.date)?.start ?? entry.date
        }
        
        return grouped
            .map { (weekStart: $0.key, entries: $0.value) }
            .sorted { $0.weekStart > $1.weekStart } // latest week first
    }

}
