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

    @State private var showAddHabit = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(habits, id: \.id) { habit in
                        NavigationLink(destination: HabitDetailView(habit: habit)) {
                            HabitRowView(habit: habit)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("My Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddHabit = true }) {
                        Label("Add Habit", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddEditHabitView()
            }
        }
    }

    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            offsets.map { habits[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting habit: \(error.localizedDescription)")
            }
        }
    }
}


