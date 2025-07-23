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

    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)],
        animation: .default
    )
    var habits: FetchedResults<Habit>

    @StateObject private var viewModel: MainHabitListViewModel

    init() {
        // Inject context via init to avoid early access to Environment
        _viewModel = StateObject(wrappedValue: MainHabitListViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(habits, id: \.id) { habit in
                        NavigationLink(destination: HabitDetailView(habit: habit)) {
                            HabitRowView(
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
                        .toolbar(.hidden, for: .tabBar)
                    }
                }
                .padding(.horizontal)
            }
            .safeAreaPadding(.bottom, 68)
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
        }
    }
}
