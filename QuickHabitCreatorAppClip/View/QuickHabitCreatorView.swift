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
                        isTracking = true
                    }
                    .disabled(habitName.isEmpty)
                    .buttonStyle(FilledButtonStyle(color: .blue))
                }
            } else {
                VStack(spacing: 16) {
                    Text("Habit: \(AppGroupStorage.getHabit() ?? "")")
                        .font(.title2)

                    if !completedToday {
                        Button("Mark as Done Today") {
                            completedToday = true
                            AppGroupStorage.saveIsCompleted()
                            scheduleReminder()
                        }
                        .buttonStyle(FilledButtonStyle(color: .green))
                    } else {
                        Text("✅ Completed today")
                            .foregroundColor(.gray)
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
                completedToday = AppGroupStorage.getIsCompleted()
                isTracking = true
            }
        }
    }

    func scheduleReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Keep it going!"
        content.body = "Remember to complete your habit tomorrow!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
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


