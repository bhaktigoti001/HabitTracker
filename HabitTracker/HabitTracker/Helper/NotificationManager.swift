//
//  NotificationManager.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import UserNotifications
import CoreData

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                print("Notifications allowed")
            } else {
                print("Notifications denied")
            }
        }
    }
    
    func scheduleNotification(for habitName: String, at date: Date, isDailyReminderOn: Bool) {
        guard isDailyReminderOn else {
            print("Daily reminder is off. No notification scheduled.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Don't forget to complete your habit: \(habitName)"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for \(date)")
            }
        }
    }
    
    func scheduleStreakRiskReminder(for habit: Habit) {
        let identifier = "streakRisk_\(habit.id?.uuidString ?? UUID().uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        guard habit.currentCount < habit.targetCount,
              let logs = habit.logs as? Set<HabitLog>,
              !hasCompletedToday(logs: logs) else {
            return
        }

        let calendar = Calendar.current
        let now = Date().startOfDay
        
        guard let eveningDate = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now),
              eveningDate > now else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "⏳ Keep Your Streak Alive"
        content.body = "You're on a streak with '\(habit.name ?? "Habit")'. Complete it before the day ends!"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: calendar.dateComponents([.hour, .minute], from: eveningDate),
            repeats: false
        )

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Streak reminder scheduled at \(eveningDate)")
            }
        }
    }
    
    private func hasCompletedToday(logs: Set<HabitLog>) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return logs.contains { log in
            guard let logDate = log.date else { return false }
            return Calendar.current.isDate(logDate, inSameDayAs: today)
        }
    }
}
