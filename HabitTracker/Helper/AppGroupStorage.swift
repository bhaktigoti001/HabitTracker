//
//  AppGroupStorage.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 30/07/25.
//

import Foundation

struct AppGroupStorage {
    static let groupID = "group.com.prodev.habittracker"
    static let habitKey = "trackedHabit"
    static let isCompletedKey = "isCompleted"
    static let migrationKey = "appClipMigrationDone"
    
    static var defaults: UserDefaults? {
        return UserDefaults(suiteName: groupID)
    }

    static func saveHabit(name: String) {
        defaults?.set(name, forKey: habitKey)
    }

    static func getHabit() -> String? {
        return defaults?.string(forKey: habitKey)
    }

    static func saveIsCompleted() {
        defaults?.set(true, forKey: isCompletedKey)
    }

    static func getIsCompleted() -> Bool {
        return defaults?.bool(forKey: isCompletedKey) ?? false
    }
    
    static func hasMigrated() -> Bool {
        return defaults?.bool(forKey: migrationKey) ?? false
    }

    static func markMigrated() {
        defaults?.set(true, forKey: migrationKey)
    }
    
    static func clear() {
        defaults?.removeObject(forKey: habitKey)
        defaults?.removeObject(forKey: isCompletedKey)
    }
}
