//
//  SettingsView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDailyReminderOn") private var isDailyReminderOn: Bool = true
    @EnvironmentObject private var appSettings: AppSettings

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $appSettings.isDarkModeOn) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                }

                Section(header: Text("Notifications")) {
                    Toggle(isOn: $isDailyReminderOn) {
                        Label("Daily Reminder", systemImage: "bell.fill")
                    }
                    .onChange(of: isDailyReminderOn) { newValue in
                        if !newValue {
                            NotificationManager.shared.cancelAllHabitNotifications()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

