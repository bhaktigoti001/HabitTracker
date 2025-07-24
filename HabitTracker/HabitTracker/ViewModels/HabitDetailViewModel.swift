//
//  HabitDetailViewModel.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 23/07/25.
//

import SwiftUI
import CoreData

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

    func incrementProgress() {
        guard habit.currentCount < habit.targetCount else { return }
        habit.currentCount += 1

        if habit.currentCount == habit.targetCount {
            logCompletion(for: habit)
        }

        save()
    }

    private func logCompletion(for habit: Habit) {
        let log = HabitLog(context: viewContext)
        log.id = UUID()
        log.date = Date()
        log.value = 1
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

    func formattedReminderTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
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
}
