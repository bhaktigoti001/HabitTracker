//
//  Enums.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 30/07/25.
//

enum Tab: Hashable, CaseIterable {
    case habits
    case settings

    var icon: String {
        switch self {
        case .habits: return "list.bullet.rectangle"
        case .settings: return "gearshape.fill"
        }
    }

    var title: String {
        switch self {
        case .habits: return "Habits"
        case .settings: return "Settings"
        }
    }
}
