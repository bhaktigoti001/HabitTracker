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
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else {
                print("Permission granted: \(granted)")
            }
        }

        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.identifier.replacingOccurrences(of: "streakRisk_", with: ""))
        let navTarget = NotificationNavigationTarget.habit(id: response.notification.request.identifier.replacingOccurrences(of: "streakRisk_", with: ""))
        self.notificationManager?.navigate(to: navTarget)
        NotificationCenter.default.post(name: .didReceiveNotificationNavigationTarget, object: navTarget)
    }
}
