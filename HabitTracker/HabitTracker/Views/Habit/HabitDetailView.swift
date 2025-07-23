//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct HabitDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showEditSheet = false
    @StateObject private var viewModel: HabitDetailViewModel
    @ObservedObject var habit: Habit

    init(habit: Habit) {
        self.habit = habit
        _viewModel = StateObject(wrappedValue: HabitDetailViewModel(habit: habit, viewContext: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                progressSection
                reminderSection
                analyticsSection
            }
            .padding()
        }
        .toolbar {
            Button {
                showEditSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showEditSheet) {
            AddEditHabitView(habit: viewModel.habit, context: viewContext)
        }
    }

    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.habit.name ?? "Untitled")
                .font(.title)
                .fontWeight(.bold)

            if let desc = viewModel.habit.desc, !desc.isEmpty {
                Text(desc)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Text("🎯 Daily Goal: \(viewModel.habit.targetCount)")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }

    @ViewBuilder
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today’s Progress")
                .font(.headline)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 12)

                    Capsule()
                        .fill(Color.green)
                        .frame(width: progressWidth(in: geometry.size.width), height: 12)
                        .animation(.easeInOut(duration: 0.4), value: viewModel.habit.currentCount)
                }
            }
            .frame(height: 12)

            HStack {
                Text("Completed \(viewModel.habit.currentCount)/\(viewModel.habit.targetCount)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text(String(format: "%.0f%%", viewModel.progressRatio * 100))
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            HStack(spacing: 16) {
                if viewModel.habit.currentCount < viewModel.habit.targetCount {
                    Button(action: {
                        viewModel.incrementProgress()
                    }) {
                        Label("Mark as Done", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }

                Spacer()

                if viewModel.habit.currentCount > 0 {
                    Button(role: .destructive, action: {
                        viewModel.resetProgress()
                    }) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.subheadline)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(.vertical)
    }

    private func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        return totalWidth * viewModel.progressRatio
    }

    @ViewBuilder
    private var reminderSection: some View {
        if let time = viewModel.habit.reminderTime {
            VStack(alignment: .leading, spacing: 8) {
                Text("⏰ Reminder")
                    .font(.headline)
                Text(viewModel.formattedReminderTime(from: time))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    @ViewBuilder
    private var analyticsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📊 Analytics (Mock)")
                .font(.headline)
            Text("🔥 Current streak: 3 days")
            Text("📆 Last completed: Yesterday")
            Text("✅ Weekly completion rate: 71%")
        }
    }
}
