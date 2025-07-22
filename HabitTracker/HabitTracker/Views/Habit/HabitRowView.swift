//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct HabitRowView: View {
    var habit: Habit
    
    var progress: CGFloat {
        CGFloat(habit.currentCount) / CGFloat(habit.targetCount)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(habit.name ?? "Unnamed").font(.headline)
            Text(habit.desc ?? "Description").font(.subheadline).foregroundColor(.secondary)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle().frame(height: 8).opacity(0.3).foregroundColor(.gray)
                    Rectangle().frame(width: geometry.size.width * progress, height: 8).foregroundColor(.blue)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
