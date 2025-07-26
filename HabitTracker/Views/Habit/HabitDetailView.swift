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
    @Binding var isDetailed: Bool
    @Binding var isHistory: Bool

    init(habit: Habit, isDetailed: Binding<Bool>, isHistory: Binding<Bool>) {
        self.habit = habit
        _isDetailed = isDetailed
        _isHistory = isHistory
        _viewModel = StateObject(wrappedValue: HabitDetailViewModel(habit: habit, viewContext: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection
                        progressSection
                    }
                }
                .padding(.vertical, 4)
                
                Section {
                    reminderSection
                        .padding(.vertical, 4)
                }
                
                Section("Analytics") {
                    analyticsSection
                        .padding(.vertical, 4)
                }
                
                Section {
                    NavigationLink(destination: HabitHistoryView(viewModel: viewModel, isHistory: $isHistory)) {
                        Label("View History", systemImage: "clock.arrow.circlepath")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .onAppear {
            isDetailed = true
            viewModel.checkIfNewDayAndReset()
        }
        .onDisappear(perform: {
            isDetailed = false
        })
        .toolbar {
            Button {
                showEditSheet = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
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
            HStack(alignment: .center, spacing: 32) {
                CircularProgressView(progress: viewModel.progressRatio)
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's Progress")
                        .font(.headline)

                    Text("Completed \(viewModel.habit.currentCount)/\(viewModel.habit.targetCount)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }

            if viewModel.habit.currentCount < viewModel.habit.targetCount {
                Button(action: {
                    withAnimation {
                        viewModel.incrementProgress()
                    }
                }) {
                    Label("Mark as Done", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.habit.currentCount)
    }

    @ViewBuilder
    private var reminderSection: some View {
        if let time = viewModel.habit.reminderTime {
            VStack(alignment: .leading, spacing: 8) {
                Text("⏰ Reminder")
                    .font(.headline)
                Text(Date().formattedReminderTime(from: time))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
    }

    @ViewBuilder
    private var analyticsSection: some View {
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
    }
}
