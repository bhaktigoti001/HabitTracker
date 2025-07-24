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
    @State private var selectedFilter: Filter = .all
    
    enum Filter: String, CaseIterable {
        case all = "All"
        case week = "This Week"
        case month = "This Month"
    }
    
    var body: some View {
        VStack {
            Picker("Filter", selection: $selectedFilter) {
                ForEach(Filter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            if filteredLogs.isEmpty {
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
            } else {
                List(filteredLogs, id: \.self) { log in
                    VStack(alignment: .leading) {
                        Text("Completed")
                            .font(.subheadline)
                        Text(Date().formattedLogDate(log.date))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("History")
    }
    
    private var filteredLogs: [HabitLog] {
        let logs = viewModel.sortedLogs
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedFilter {
        case .all:
            return logs
        case .week:
            return logs.filter {
                guard let logDate = $0.date, let startOfWeek = Date().startOfWeek, let endOfWeek = Date().endOfWeek else { return false }
                return logDate >= startOfWeek && logDate <= endOfWeek
            }
        case .month:
            return logs.filter {
                guard let date = $0.date else { return false }
                return calendar.isDate(date, equalTo: now, toGranularity: .month)
            }
        }
    }
}
