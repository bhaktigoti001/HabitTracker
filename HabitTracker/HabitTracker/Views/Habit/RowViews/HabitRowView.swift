//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct HabitRowView: View {
    @State private var showConfirmDelete = false
    
    var habit: Habit
    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(habit.name ?? "Untitled")
                    .font(.headline)
                Text(habit.desc ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
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
                }
                
                if let _ = onDelete {
                    Button(role: .destructive) {
                        showConfirmDelete = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .alert("Are you sure you want to delete this habit?", isPresented: $showConfirmDelete) {
            Button("Delete", role: .destructive) {
                onDelete?()
            }
            Button("Cancel", role: .cancel) { }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
