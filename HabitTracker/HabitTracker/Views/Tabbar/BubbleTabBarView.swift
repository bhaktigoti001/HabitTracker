//
//  BubbleTabBarView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 23/07/25.
//

import SwiftUI

enum Tab {
    case habits
    case settings
}

struct BubbleTabBarView: View {
    @State private var selectedTab: Tab = .habits
    @EnvironmentObject private var appSettings: AppSettings
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content based on selected tab
            Group {
                switch selectedTab {
                case .habits:
                    NavigationStack {
                        MainHabitListView()
                            .preferredColorScheme(appSettings.colorScheme)
                    }
                case .settings:
                    NavigationStack {
                        SettingsView()
                            .environmentObject(appSettings)
                            .preferredColorScheme(appSettings.colorScheme)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))

            // Custom Bubble Tab Bar
            HStack(spacing: 40) {
                tabButton(.habits, icon: "list.bullet.rectangle", title: "Habits")
                tabButton(.settings, icon: "gearshape.fill", title: "Settings")
            }
            .padding(.all, 12)
            .background(
                Capsule()
                    .fill(appSettings.colorScheme == .dark ? Color(.systemGray5) : .white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
            )
            .padding(.bottom, 24)
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    private func tabButton(_ tab: Tab, icon: String, title: String) -> some View {
        Button {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if selectedTab == tab {
                        HStack {
                            Image(systemName: icon)
                                .foregroundColor(.blue)
                                .font(.system(size: 20, weight: .medium))
                            
                            Text(title)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .transition(.opacity.combined(with: .scale))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(
                            Capsule()
                                .fill(.blue.opacity(0.3))
                        )
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
