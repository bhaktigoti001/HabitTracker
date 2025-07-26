//
//  HabitAnalytics.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//


import Foundation
import CoreData

struct HabitAnalytics {
    private let habit: Habit

    init(habit: Habit) {
        self.habit = habit
    }
    
    func currentStreak() -> Int {
        guard let logs = habit.logs as? Set<HabitLog> else { return 0 }
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let uniqueLogDates = logs
            .filter({ $0.value == habit.targetCount })
            .compactMap { $0.date }
            .map { calendar.startOfDay(for: $0) }
        
        let completedDaysSet = Set(uniqueLogDates)
        
        var streak = 0
        var currentDay = calendar.startOfDay(for: Date().timezoneDate)
        
        if !completedDaysSet.contains(currentDay) {
            currentDay = calendar.date(byAdding: .day, value: -1, to: currentDay)!
        }
        
        while completedDaysSet.contains(currentDay) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else {
                break
            }
            currentDay = previousDay
        }
        
        return streak
    }

    func lastCompletedDate() -> String {
        guard let logSet = habit.logs as? Set<HabitLog> else {
            return "No Completion"
        }

        guard let lastDate = logSet
            .filter({ $0.value == habit.targetCount })
            .compactMap({ $0.date })
            .max() else {
            return "No Completion"
        }

        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let now = calendar.startOfDay(for: Date().timezoneDate)
        let logDay = calendar.startOfDay(for: lastDate)
        let dayDiff = calendar.dateComponents([.day], from: logDay, to: now).day ?? 0

        switch dayDiff {
        case 0: return "Today"
        case 1: return "Yesterday"
        case 2...6:
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "EEEE"
            return formatter.string(from: lastDate)
        default:
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateStyle = .medium
            return formatter.string(from: lastDate)
        }
    }

    func weeklyCompletionRate() -> String {
        guard let logSet = habit.logs as? Set<HabitLog> else {
            return "0%"
        }

        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let today = calendar.startOfDay(for: Date().timezoneDate)
        
        guard let startOfWeek = today.startOfWeek else {
                return "0%"
            }

        let completedDays = Set<Date>(
            logSet.compactMap { log in
                guard let date = log.date else { return nil }
                let day = calendar.startOfDay(for: date)
                return (log.value == habit.targetCount && day >= startOfWeek && day <= today) ? day : nil
            }
        )

        let percentage = (Double(completedDays.count) / 7.0) * 100
        return String(format: "%.0f%%", percentage)
    }
}
