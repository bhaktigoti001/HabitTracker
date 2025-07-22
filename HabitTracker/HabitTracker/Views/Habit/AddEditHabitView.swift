//
//  AddEditHabitView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct AddEditHabitView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @AppStorage("isDailyReminderOn") var isDailyReminderOn: Bool = true

    @State private var name = ""
    @State private var description = ""
    @State private var targetCount: Int16 = 1
    @State private var reminderTime = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Habit Name", text: $name)
                TextField("Description", text: $description)
                Stepper("Target per day: \(targetCount)", value: $targetCount, in: 1...10)
                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
            }
            .navigationTitle("Add Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addHabit()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func addHabit() {
        let newHabit = Habit(context: viewContext)
        newHabit.id = UUID()
        newHabit.name = name
        newHabit.desc = description
        newHabit.targetCount = targetCount
        newHabit.currentCount = 0
        newHabit.reminderTime = reminderTime
        
        try? viewContext.save()
        NotificationManager.shared.scheduleNotification(for: name, at: reminderTime, isDailyReminderOn: isDailyReminderOn)
    }
}

