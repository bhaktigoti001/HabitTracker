//
//  AddEditHabitViewModel.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 23/07/25.
//

import Foundation
import CoreData
import SwiftUI

class AddEditHabitViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var desc: String = ""
    @Published var targetCount: Int = 1
    @Published var enableReminder: Bool = false
    @Published var reminderTime: Date = Date()

    @Published var habit: Habit?
    @AppStorage("isDailyReminderOn") var isDailyReminderOn: Bool = true
    
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext, habit: Habit? = nil) {
        self.context = context
        self.habit = habit

        if let habit = habit {
            self.name = habit.name ?? ""
            self.desc = habit.desc ?? ""
            self.targetCount = Int(habit.targetCount)
            self.enableReminder = habit.reminderTime != nil
            self.reminderTime = habit.reminderTime ?? Date().timezoneDate
        }
    }

    func save() {
        let isNew = habit == nil
        let habitToSave = habit ?? Habit(context: context)

        if isNew {
            habitToSave.id = UUID()
            habitToSave.currentCount = 0
            habitToSave.createdAt = Date().timezoneDate
        }

        habitToSave.name = name
        habitToSave.desc = desc
        habitToSave.targetCount = Int16(targetCount)
        habitToSave.reminderTime = enableReminder ? reminderTime : nil
        habitToSave.updatedAt = Date().timezoneDate

        do {
            try context.save()
            if isNew {
                NotificationManager.shared.scheduleNotification(for: name, at: reminderTime, isDailyReminderOn: isDailyReminderOn)
            }
        } catch {
            print("Failed to save habit: \(error.localizedDescription)")
        }
    }
}
