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
    
    let persistenceController = PersistenceController.shared
    
    init() {
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            BubbleTabBarView()
                .preferredColorScheme(appSettings.colorScheme)
                .environmentObject(appSettings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
