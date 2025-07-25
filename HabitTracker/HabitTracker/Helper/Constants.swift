//
//  Constants.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 25/07/25.
//

import Foundation

extension Notification.Name {
    static let didReceiveNotificationNavigationTarget = Notification.Name("didReceiveNotificationNavigationTarget")
}

enum NotificationNavigationTarget: Identifiable, Hashable {
    case habit(id: String)
    
    var id: String {
        switch self {
        case .habit(let id):
            return id
        }
    }
}
