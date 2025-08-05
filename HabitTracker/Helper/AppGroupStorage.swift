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
    static let lastCompletedDateKey = "lastCompletedDate"
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

    static func saveCompletedDays() {
        var list = AppGroupStorage.getCompletedDays()
        list.append(Date())
        defaults?.set(list, forKey: isCompletedKey)
    }

    static func getCompletedDays() -> [Date] {
        return defaults?.array(forKey: isCompletedKey) as? [Date] ?? []
    }
    
    static func hasMigrated() -> Bool {
        return defaults?.bool(forKey: migrationKey) ?? false
    }

    static func markMigrated() {
        defaults?.set(true, forKey: migrationKey)
    }

    static var lastCompletedDate: Date? {
        get { defaults?.object(forKey: lastCompletedDateKey) as? Date }
        set { defaults?.set(newValue, forKey: lastCompletedDateKey) }
    }

    static func completedToday() -> Bool {
        guard let date = lastCompletedDate else { return false }
        return Calendar.current.isDateInToday(date)
    }
    
    static func completedYesterday() -> Bool {
        guard let date = lastCompletedDate else { return false }
        return Calendar.current.isDateInYesterday(date)
    }
    
    static func clear() {
        defaults?.removeObject(forKey: habitKey)
        defaults?.removeObject(forKey: isCompletedKey)
        defaults?.removeObject(forKey: lastCompletedDateKey)
    }
}
