//
//  AppDelegate.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var notificationManager: NotificationNavigationManager?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        NotificationManager.shared.configure(delegate: self)
        NotificationManager.shared.requestPermission()

        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let identifier = response.notification.request.identifier
        guard let navTarget = parseNotificationIdentifier(identifier) else {
            print("⚠️ Unrecognized or invalid notification identifier: \(identifier)")
            completionHandler()
            return
        }

        if let manager = notificationManager {
            manager.navigate(to: navTarget)
        } else {
            print("⚠️ NotificationManager not available. Deferring navigation.")
        }

        NotificationCenter.default.post(name: .didReceiveNotificationNavigationTarget, object: navTarget)
        completionHandler()
    }

    private func parseNotificationIdentifier(_ identifier: String) -> NotificationNavigationTarget? {
        if identifier.hasPrefix("habit_") {
            let habitId = identifier.replacingOccurrences(of: "habit_", with: "")
            return habitId.isEmpty ? nil : .habit(id: habitId)
        }

        if identifier.hasPrefix("streakRisk_") {
            let habitId = identifier.replacingOccurrences(of: "streakRisk_", with: "")
            return habitId.isEmpty ? nil : .habit(id: habitId) // or use a different target type if you want
        }

        return nil
    }

}
