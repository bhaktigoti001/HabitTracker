//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

@main
struct HabitTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appSettings = AppSettings()
    @StateObject var notificationManager = NotificationNavigationManager()
    
    let persistenceController = PersistenceController.shared
    
    init() {
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
//            TabView {
//                MainHabitListView()
//                    .preferredColorScheme(appSettings.colorScheme)
//                    .tabItem {
//                        Label("Habits", systemImage: "list.bullet")
//                    }
//                SettingsView()
//                    .environmentObject(appSettings)
//                    .preferredColorScheme(appSettings.colorScheme)
//                    .tabItem {
//                        Label("Settings", systemImage: "gear")
//                    }
//            }
//            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
            BubbleTabBarView()
                .environmentObject(notificationManager)
                .preferredColorScheme(appSettings.colorScheme)
                .environmentObject(appSettings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onReceive(NotificationCenter.default.publisher(for: .didReceiveNotificationNavigationTarget)) { notification in
                    if let target = notification.object as? NotificationNavigationTarget {
                        notificationManager.navigate(to: target)
                    }
                }
                .onAppear {
                    appDelegate.notificationManager = notificationManager
                }
        }
    }
}
