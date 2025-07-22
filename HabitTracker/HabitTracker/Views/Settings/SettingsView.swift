//
//  SettingsView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 22/07/25.
//

import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("isDarkModeOn") var isDarkModeOn: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }

    var colorScheme: ColorScheme? {
        isDarkModeOn ? .dark : .light
    }
}


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
