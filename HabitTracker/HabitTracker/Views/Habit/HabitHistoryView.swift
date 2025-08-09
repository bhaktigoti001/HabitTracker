//
//  HabitHistoryView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//

import SwiftUI
import Charts

struct HabitHistoryView: View {
    @ObservedObject var viewModel: HabitDetailViewModel
    @Binding var isHistory: Bool

    @State private var selectedFilter: HabitLogFilter = .all

    var body: some View {
        VStack {
            filterPicker
                .padding(.horizontal)
                .padding(.bottom, 8)

            if viewModel.filteredLogs(for: selectedFilter).isEmpty {
                emptyPlaceholder
            } else {
                logList
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            isHistory = true
        }
        .onDisappear {
            isHistory = false
        }
    }

    @ViewBuilder
    private var filterPicker: some View {
        Picker("Filter", selection: $selectedFilter) {
            ForEach(HabitLogFilter.allCases) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    private var emptyPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.4))

            Text("No history available for this filter.")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var logList: some View {
        let grouped = viewModel.groupedLogsByWeek(for: selectedFilter)
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(grouped, id: \.weekStart)  { group in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(Date.formattedWeekRange(startDate: group.weekStart))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 5)

                        ForEach(group.entries) { entry in
                            DailyHistoryLogCard(entry: entry)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
