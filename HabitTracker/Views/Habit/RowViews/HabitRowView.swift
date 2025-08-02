//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct HabitRowView: View {
    @Binding var isDetailed: Bool
    @Binding var isHistory: Bool
    @State private var showConfirmDelete = false
    @State private var showDetail = false
    
    var habit: Habit
    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            showDetail = true
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Untitled")
                        .font(.headline)
                        .lineLimit(1)
                    
                    if let desc = habit.desc, !desc.isEmpty {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    if let onEdit = onEdit {
                        Button {
                            onEdit()
                        } label: {
                            Image(systemName: "pencil")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .accessibilityLabel("Edit Habit")
                    }
                    
                    if let _ = onDelete {
                        Button(role: .destructive) {
                            showConfirmDelete = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .accessibilityLabel("Delete Habit")
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showDetail) {
            HabitDetailView(habit: habit, isDetailed: $isDetailed, isHistory: $isHistory)
        }
        .alert("Are you sure you want to delete this habit?", isPresented: $showConfirmDelete) {
            Button("Delete", role: .destructive) {
                onDelete?()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}
