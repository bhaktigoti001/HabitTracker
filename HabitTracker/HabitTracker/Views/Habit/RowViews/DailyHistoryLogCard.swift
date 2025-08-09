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
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: entry.status.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(entry.status.accentColor)
                .padding(9)
                .background(entry.status.accentColor.opacity(0.15))
                .clipShape(Circle())

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

            Text("✅ \(entry.count)/\(entry.goal) completed")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(entry.status == .missed ? .red : .secondary)
        }
        .padding(15)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .shadow(color: Color.primary.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}
