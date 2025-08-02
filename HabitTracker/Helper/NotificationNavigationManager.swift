//
//  NotificationNavigationManager.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 25/07/25.
//

import SwiftUI

class NotificationNavigationManager: ObservableObject {
    @Published var currentTarget: NotificationNavigationTarget?
    
    func navigate(to target: NotificationNavigationTarget?) {
        guard self.currentTarget != target else { return }
        self.currentTarget = target
    }

    func clear() {
        currentTarget = nil
    }
}
