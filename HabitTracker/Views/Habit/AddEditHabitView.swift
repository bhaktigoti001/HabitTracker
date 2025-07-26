//
//  AddEditHabitView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI
import CoreData

struct AddEditHabitView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddEditHabitViewModel

    init(habit: Habit? = nil, context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: AddEditHabitViewModel(context: context, habit: habit))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit Details") {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.desc)
                    Stepper("Target: \(viewModel.targetCount)", value: $viewModel.targetCount, in: 1...10)
                }

                Section("Reminder") {
                    Toggle("Enable Reminder", isOn: $viewModel.enableReminder)
                    if viewModel.enableReminder {
                        DatePicker("Time", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle(viewModel.habit == nil ? "Add Habit" : "Edit Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                }
            }
        }
    }
}
