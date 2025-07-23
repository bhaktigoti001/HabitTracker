//
//  SettingsView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDailyReminderOn") var isDailyReminderOn: Bool = true
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        NavigationStack {
            Form {
                Toggle("Dark Mode", isOn: $appSettings.isDarkModeOn)
                Toggle("Daily Reminder", isOn: $isDailyReminderOn)
            }
            .navigationTitle("Settings")
        }
    }
}
