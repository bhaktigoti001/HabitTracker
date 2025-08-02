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
    @State private var showValidationError = false
    
    init(habit: Habit? = nil, context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: AddEditHabitViewModel(context: context, habit: habit))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Name", text: $viewModel.name)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(false)
                    
                    TextField("Description", text: $viewModel.desc)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                    
                    Stepper(value: $viewModel.targetCount, in: 1...10) {
                        Label("Target: \(viewModel.targetCount)", systemImage: "flag.fill")
                    }
                }

                Section(header: Text("Reminder")) {
                    Toggle(isOn: $viewModel.enableReminder.animation(.easeInOut)) {
                        Label("Enable Reminder", systemImage: "bell.fill")
                    }
                    
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
                        if viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showValidationError = true
                        } else {
                            viewModel.save()
                            dismiss()
                        }
                    }
                    .disabled(viewModel.name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .alert("Habit name can't be empty.", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
