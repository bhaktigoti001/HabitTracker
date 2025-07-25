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
    @Binding var isDetailed: Bool
    @Binding var isHistory: Bool

    init(isDetailed: Binding<Bool>, isHistory: Binding<Bool>) {
        _isDetailed = isDetailed
        _isHistory = isHistory
        _viewModel = StateObject(wrappedValue: MainHabitListViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationStack {
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
