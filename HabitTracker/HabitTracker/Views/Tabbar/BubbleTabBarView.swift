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
    @State private var isDetailed = false
    @State private var isHistory = false
    @EnvironmentObject private var appSettings: AppSettings
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .habits:
                    MainHabitListView(isDetailed: $isDetailed, isHistory: $isHistory)
                        .preferredColorScheme(appSettings.colorScheme)
                case .settings:
                    SettingsView()
                        .environmentObject(appSettings)
                        .preferredColorScheme(appSettings.colorScheme)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))

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
            .opacity((isDetailed || isHistory) ? 0 : 1)
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
