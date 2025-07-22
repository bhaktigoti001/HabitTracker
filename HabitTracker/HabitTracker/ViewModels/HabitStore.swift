//
//  HabitStore.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import Foundation
import SwiftUI

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    
    func add(_ habit: Habit) {
        habits.append(habit)
    }
    
    func update(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
    }
}
