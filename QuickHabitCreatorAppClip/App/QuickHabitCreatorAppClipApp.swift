//
//  QuickHabitCreatorAppClipApp.swift
//  QuickHabitCreatorAppClip
//
//  Created by DREAMWORLD on 30/07/25.
//

import SwiftUI
import UserNotifications

@main
struct QuickHabitCreatorAppClipApp: App {
    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            QuickHabitCreatorView()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
}
