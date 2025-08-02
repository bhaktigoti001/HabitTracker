//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct HabitDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: HabitDetailViewModel
    @State private var showEditSheet = false

    @ObservedObject var habit: Habit
    @Binding var isDetailed: Bool
    @Binding var isHistory: Bool

    init(habit: Habit, isDetailed: Binding<Bool>, isHistory: Binding<Bool>) {
        self.habit = habit
        _isDetailed = isHistory
        _isHistory = isHistory
        _viewModel = StateObject(wrappedValue: HabitDetailViewModel(habit: habit, viewContext: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationStack {
            List {
                headerSection
                progressSection
                if viewModel.habit.reminderTime != nil {
                    reminderSection
                }
                analyticsSection
                historyLinkSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Habit Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showEditSheet = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
            .sheet(isPresented: $showEditSheet) {
                AddEditHabitView(habit: viewModel.habit, context: viewContext)
            }
            .onAppear {
                isDetailed = true
                viewModel.checkIfNewDayAndReset()
            }
            .onDisappear {
                isDetailed = false
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.habit.name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Untitled")
                    .font(.title)
                    .fontWeight(.bold)

                if let desc = viewModel.habit.desc, !desc.trimmingCharacters(in: .whitespaces).isEmpty {
                    Text(desc)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                Text("🎯 Daily Goal: \(viewModel.habit.targetCount)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Progress

    private var progressSection: some View {
        Section {
            VStack(spacing: 16) {
                HStack(alignment: .center, spacing: 24) {
                    CircularProgressView(progress: viewModel.progressRatio)
                        .frame(width: 90, height: 90)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Progress")
                            .font(.headline)
                        Text("Completed \(viewModel.habit.currentCount)/\(viewModel.habit.targetCount)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                if viewModel.habit.currentCount < viewModel.habit.targetCount {
                    Button(action: {
                        withAnimation {
                            viewModel.incrementProgress()
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }) {
                        Label("Mark as Done", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .transition(.opacity)
                }
            }
            .padding(.vertical, 8)
        }
        .animation(.easeInOut, value: viewModel.habit.currentCount)
    }

    // MARK: - Reminder

    private var reminderSection: some View {
        Section(header: Text("Reminder")) {
            VStack(alignment: .leading, spacing: 6) {
                Text("⏰ Reminder Time")
                    .font(.headline)
                Text(Date().formattedReminderTime(from: viewModel.habit.reminderTime!))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    // MARK: - Analytics

    private var analyticsSection: some View {
        Section(header: Text("Analytics")) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 0) {
                    Text("🔥 Current streak: ").bold()
                    Text("\(viewModel.currentStreak()) days")
                }

                HStack(spacing: 0) {
                    Text("📆 Last completed: ").bold()
                    Text(viewModel.lastCompletedDate())
                }

                HStack(spacing: 0) {
                    Text("✅ Weekly completion rate: ").bold()
                    Text(viewModel.weeklyCompletionRate())
                }
            }
            .font(.subheadline)
        }
    }

    // MARK: - History

    private var historyLinkSection: some View {
        Section {
            NavigationLink(destination: HabitHistoryView(viewModel: viewModel, isHistory: $isHistory)) {
                Label("View History", systemImage: "clock.arrow.circlepath")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }
}
