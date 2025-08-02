//
//  MainHabitListView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI
import CoreData

struct MainHabitListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var notificationManager: NotificationNavigationManager

    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.createdAt, ascending: false)],
        animation: .default
    )
    private var habits: FetchedResults<Habit>

    @StateObject private var viewModel: MainHabitListViewModel
    @Binding var isDetailed: Bool
    @Binding var isHistory: Bool
    @State private var navigationTarget: NotificationNavigationTarget?
    
    init(isDetailed: Binding<Bool>, isHistory: Binding<Bool>) {
        _isDetailed = isDetailed
        _isHistory = isHistory
        _viewModel = StateObject(wrappedValue: MainHabitListViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "list.bullet.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.4))
                        
                        Text("No habits yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Tap the '+' button to create your first habit.")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(habits, id: \.id) { habit in
                            HabitRowView(
                                isDetailed: $isDetailed,
                                isHistory: $isHistory,
                                habit: habit,
                                onEdit: {
                                    viewModel.startEditFlow(for: habit)
                                },
                                onDelete: {
                                    viewModel.deleteHabit(habit)
                                }
                            )
                            .padding(.vertical, 4)
                        }
                    }
                    .safeAreaPadding(.bottom, 48)
                }
            }
            .navigationTitle("My Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.startAddFlow()
                    } label: {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddHabit) {
                AddEditHabitView(habit: viewModel.selectedHabit, context: viewContext)
            }
            .onAppear {
                viewModel.migrateAppClipHabitIfNeeded()
                for habit in habits {
                    NotificationManager.shared.scheduleStreakRiskReminder(for: habit)
                }
            }
            .onChange(of: notificationManager.currentTarget) { newTarget in
                if let target = newTarget {
                    navigationTarget = newTarget
                    notificationManager.clear()
                }
            }
            .navigationDestination(item: $navigationTarget) { target in
                switch target {
                case .habit(let id):
                    if let habit = habits.first(where: { $0.id?.uuidString ?? "" == id }) {
                        HabitDetailView(habit: habit, isDetailed: $isDetailed, isHistory: $isHistory)
                    }
                }
            }
        }
    }
}
