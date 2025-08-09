//
//  AppInfo.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//

import Foundation

class AppInfo {
    static let shared = AppInfo()
    
    private let installKey = "firstInstallDate"

    var installDate: Date {
        if let saved = UserDefaults.standard.object(forKey: installKey) as? Date {
            return saved
        } else {
            let now = Date()
            UserDefaults.standard.set(now, forKey: installKey)
            return now
        }
    }
}
