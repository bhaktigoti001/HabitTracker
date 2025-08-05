//
//  MainHabitListViewModel.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 23/07/25.
//

import Foundation
import CoreData
import SwiftUI

class MainHabitListViewModel: ObservableObject {
    @Published var selectedHabit: Habit? = nil
    @Published var showAddHabit: Bool = false
    
    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func deleteHabit(_ habit: Habit) {
        viewContext.delete(habit)
        do {
            try viewContext.save()
            if let id = habit.id?.uuidString {
                NotificationManager.shared.cancelNotification(for: id)
            }
        } catch {
            print("Error deleting habit: \(error.localizedDescription)")
        }
    }

    func startAddFlow() {
        selectedHabit = nil
        showAddHabit = true
    }

    func startEditFlow(for habit: Habit) {
        selectedHabit = habit
        showAddHabit = true
    }
    
    func migrateAppClipHabitIfNeeded() {
        // ❌ Skip if already migrated
        guard !AppGroupStorage.hasMigrated() else { return }

        // ❌ Skip if Core Data already has habits
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.fetchLimit = 1

        if let result = try? viewContext.fetch(request), !result.isEmpty {
            AppGroupStorage.markMigrated()
            return
        }

        guard let clipHabitName = AppGroupStorage.getHabit(),
              !clipHabitName.isEmpty else {
            AppGroupStorage.markMigrated()
            return
        }

        let newHabit = Habit(context: viewContext)
        newHabit.id = UUID()
        newHabit.name = clipHabitName
        newHabit.targetCount = 1
        newHabit.createdAt = AppGroupStorage.getCompletedDays().first?.timezoneDate
        newHabit.currentCount = AppGroupStorage.completedToday() ? 1 : 0
        
        for date in AppGroupStorage.getCompletedDays() {
            logCompletion(date: date, newHabit: newHabit)
        }
        
        do {
            try viewContext.save()
            AppGroupStorage.clear()
            AppGroupStorage.markMigrated()
            print("✅ Migrated App Clip habit into Core Data")
        } catch {
            print("❌ Failed to migrate App Clip habit: \(error)")
        }
    }
    
    private func logCompletion(date: Date, newHabit: Habit) {
        let log = HabitLog(context: viewContext)
        log.id = UUID()
        log.date = date.timezoneDate
        log.value = 1
        log.habit = newHabit
    }
    
    private func save() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save progress: \(error)")
        }
    }

}
