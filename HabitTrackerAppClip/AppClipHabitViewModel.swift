//
//  AppClipHabitViewModel.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 29/07/25.
//


import SwiftUI
import CoreData

class AppClipHabitViewModel: ObservableObject {
    @Published var habit: Habit?
    @Published var habits: [Habit] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = AppClipPersistence.shared.container.viewContext) {
        self.context = context
        fetchAllHabits()
    }

    func fetchAllHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.name, ascending: true)]

        do {
            let result = try context.fetch(request).first
            DispatchQueue.main.async {
                self.habit = result
            }
        } catch {
            print("Failed to fetch habits in App Clip: \(error)")
        }
    }

    func loadHabit(by id: UUID) {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            self.habit = try context.fetch(request).first
        } catch {
            print("Error loading habit by ID: \(error)")
        }
    }

    var progressRatio: CGFloat {
        guard let habit = habit, habit.targetCount > 0 else { return 0 }
        return CGFloat(habit.currentCount) / CGFloat(habit.targetCount)
    }

    func incrementProgress() {
        guard let habit = habit else { return }

        if habit.currentCount < habit.targetCount {
            habit.currentCount += 1
        }

        // Log completion if reached
        if habit.currentCount == habit.targetCount {
            logCompletion(for: habit)
        }

        save()
    }

    private func logCompletion(for habit: Habit) {
        let log = HabitLog(context: context)
        log.id = UUID()
        log.date = Date()
        log.habit = habit
        log.value = habit.currentCount

        save()
    }

    private func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save habit in App Clip: \(error)")
        }
    }
}
