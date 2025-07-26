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
}
