//
//  BubbleTabBar.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 30/07/25.
//

import SwiftUI

struct BubbleTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(spacing: 40) {
            ForEach(Tab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(12)
        .background(
            Capsule()
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        )
    }

    @ViewBuilder
    private func tabButton(for tab: Tab) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedTab = tab
            }
        } label: {
            if selectedTab == tab {
                HStack(spacing: 6) {
                    Image(systemName: tab.icon)
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .medium))

                    Text(tab.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .transition(.opacity.combined(with: .scale))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(
                    Capsule()
                        .fill(.blue.opacity(0.2))
                )
            } else {
                Image(systemName: tab.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
        }
    }
}
