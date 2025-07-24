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
                .padding()

            if viewModel.filteredLogs(for: selectedFilter).isEmpty {
                emptyPlaceholder
            } else {
                logList
            }
        }
        .onAppear(perform: {
            isHistory = true
        })
        .onDisappear(perform: {
            isHistory = false
        })
        .navigationTitle("History")
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
                .foregroundColor(.gray.opacity(0.5))

            Text("No history available")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var logList: some View {
        List(viewModel.filteredLogs(for: selectedFilter), id: \.self) { log in
            VStack(alignment: .leading, spacing: 4) {
                Text("✅ Completed")
                    .font(.subheadline)
                if let date = log.date {
                    Text(Date().formattedLogDate(date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
