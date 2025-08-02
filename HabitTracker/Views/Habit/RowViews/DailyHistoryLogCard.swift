//
//  DailyHistoryLogCard.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 09/08/25.
//

import SwiftUI

struct DailyHistoryLogCard: View {
    let entry: HabitLogEntry

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            statusIcon

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date.formattedLogDate())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(entry.status.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            completionStatus
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(entry.date.formattedLogDate()), status: \(entry.status.title), \(entry.count) out of \(entry.goal) completed")
    }
    
    private var statusIcon: some View {
        Image(systemName: entry.status.iconName)
            .resizable()
            .scaledToFit()
            .frame(width: 22, height: 22)
            .foregroundColor(entry.status.accentColor)
            .padding(10)
            .background(entry.status.accentColor.opacity(0.15))
            .clipShape(Circle())
    }
    
    private var completionStatus: some View {
        let color: Color = entry.status == .missed ? .red : .secondary
        return Text("✅ \(entry.count)/\(entry.goal)")
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(color)
    }
}
