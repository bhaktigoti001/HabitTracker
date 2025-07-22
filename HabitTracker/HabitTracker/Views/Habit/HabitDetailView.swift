//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct HabitDetailView: View {
    let habit: Habit
    
    var body: some View {
        VStack(spacing: 20) {
            Text(habit.name ?? "Unnamed").font(.largeTitle)
            Text("Target: \(habit.targetCount) times/day")
            Text("Current: \(habit.currentCount)")
            Divider()
            Text("Analytics (mock)").italic()
            Spacer()
        }
        .padding()
        .navigationTitle("Habit Details")
    }
}
