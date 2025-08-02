//
//  HabitHistoryView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//

import SwiftUI

struct HabitHistoryView: View {
    @ObservedObject var viewModel: HabitDetailViewModel
    @Binding var isHistory: Bool

    @State private var selectedFilter: HabitLogFilter = .all

    var body: some View {
        VStack(spacing: 0) {
            filterPicker
                .padding([.top, .horizontal])
                .padding(.bottom, 8)

            Group {
                if viewModel.filteredLogs(for: selectedFilter).isEmpty {
                    emptyPlaceholder
                        .transition(.opacity.combined(with: .slide))
                } else {
                    logList
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut, value: selectedFilter)
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            isHistory = true
        }
        .onDisappear {
            isHistory = false
        }
    }
    
    // MARK: - Filter Picker

    @ViewBuilder
    private var filterPicker: some View {
        Picker("Filter", selection: $selectedFilter) {
            ForEach(HabitLogFilter.allCases) { filter in
                Text(filter.rawValue).tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel("History Filter")
    }

    // MARK: - Empty Placeholder
    
    @ViewBuilder
    private var emptyPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.badge.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.3))

            Text("No logs available")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Try adjusting the filter to view other entries.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Log List
    
    @ViewBuilder
    private var logList: some View {
        let grouped = viewModel.groupedLogsByWeek(for: selectedFilter)
        
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(grouped, id: \.weekStart)  { group in
                    Section {
                        Text(Date.formattedWeekRange(startDate: group.weekStart))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 5)
                        
                        ForEach(group.entries) { entry in
                            DailyHistoryLogCard(entry: entry)
                                .padding(.horizontal, 5)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
