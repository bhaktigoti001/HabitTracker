//
//  AppSettings.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 23/07/25.
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
