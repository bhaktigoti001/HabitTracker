//
//  QuickHabitCreatorView.swift
//  QuickHabitCreatorAppClip
//
//  Created by DREAMWORLD on 30/07/25.
//

import SwiftUI
import UserNotifications

struct QuickHabitCreatorView: View {
    @State private var habitName: String = ""
    @State private var isTracking = false
    @State private var completedToday = false

    var body: some View {
        VStack(spacing: 24) {
            Text("🎯 Quick Habit Tracker")
                .font(.largeTitle)
                .bold()

            if !isTracking {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Enter a habit to track today:")
                        .font(.headline)

                    TextField("e.g. Drink Water", text: $habitName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Start Tracking") {
                        AppGroupStorage.saveHabit(name: habitName)
                        scheduleOneTimeReminder(habitName: habitName)
                        isTracking = true
                    }
                    .disabled(habitName.isEmpty)
                    .buttonStyle(FilledButtonStyle(color: .blue))
                }
            } else {
                VStack(spacing: 16) {
                    Text("Habit: \(AppGroupStorage.getHabit() ?? "")")
                        .font(.title2)

                    if AppGroupStorage.completedYesterday() && !completedToday {
                        Text("👏 You completed your habit yesterday too!")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    if !completedToday {
                        Button("Mark as Done Today") {
                            completedToday = true
                            AppGroupStorage.lastCompletedDate = Date()
                            AppGroupStorage.saveCompletedDays()
                        }
                        .buttonStyle(FilledButtonStyle(color: .green))
                    } else {
                        Text("✅ You've completed this habit today!")
                            .foregroundColor(.green)
                    }
                }
            }

            Spacer()

            if isTracking {
                Link("Continue in Full App", destination: URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!)
                    .buttonStyle(FilledButtonStyle(color: .purple))
            }
        }
        .padding()
        .onAppear {
            if let saved = AppGroupStorage.getHabit() {
                habitName = saved
                isTracking = true
                completedToday = AppGroupStorage.completedToday()
            }
        }
    }
    
    func scheduleOneTimeReminder(habitName: String, after timeInterval: TimeInterval = 10) {
        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Don't forget to complete your habit: \(habitName)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(identifier: "appclip_habit_reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ App Clip notification error: \(error)")
            } else {
                print("✅ App Clip reminder scheduled in \(Int(timeInterval / 60)) minutes")
            }
        }
    }
}

struct FilledButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(color.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
