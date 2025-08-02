//
//  BubbleTabBarView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 23/07/25.
//

import SwiftUI

struct BubbleTabBarView: View {
    @State private var selectedTab: Tab = .habits
    @State private var isDetailed = false
    @State private var isHistory = false
    
    @EnvironmentObject private var appSettings: AppSettings
    @EnvironmentObject var notificationManager: NotificationNavigationManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .habits:
                    MainHabitListView(isDetailed: $isDetailed, isHistory: $isHistory)
                        .environmentObject(notificationManager)
                    
                case .settings:
                    SettingsView()
                        .environmentObject(appSettings)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .preferredColorScheme(appSettings.colorScheme)
            
            if !(isDetailed || isHistory) {
                BubbleTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 24)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeInOut(duration: 0.3), value: isDetailed || isHistory)
    }
}
