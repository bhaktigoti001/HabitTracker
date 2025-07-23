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

    init(habit: Habit, viewContext: NSManagedObjectContext) {
        self.habit = habit
        self.viewContext = viewContext
    }

    var progressRatio: CGFloat {
        guard habit.targetCount > 0 else { return 0 }
        return CGFloat(habit.currentCount) / CGFloat(habit.targetCount)
    }

    func incrementProgress() {
        guard habit.currentCount < habit.targetCount else { return }
        habit.currentCount += 1
        save()
    }

    func resetProgress() {
        habit.currentCount = 0
        save()
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
}
