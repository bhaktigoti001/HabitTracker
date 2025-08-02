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
    
    var body: some Scene {
        WindowGroup {
            BubbleTabBarView()
                .injectGlobalEnvironmentObjects(
                       notificationManager: notificationManager,
                       appSettings: appSettings,
                       context: persistenceController.container.viewContext
                   )
                .onReceive(NotificationCenter.default.publisher(for: .didReceiveNotificationNavigationTarget)) { notification in
                    if let target = notification.object as? NotificationNavigationTarget {
                        notificationManager.navigate(to: target)
                    }
                }
                .onAppear {
                    NotificationManager.shared.requestPermission()
                    appDelegate.notificationManager = notificationManager
                }
        }
    }
}
