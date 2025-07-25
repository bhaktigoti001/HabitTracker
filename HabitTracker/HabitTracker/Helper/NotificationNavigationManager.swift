//
//  NotificationNavigationManager.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 25/07/25.
//

import SwiftUI

class NotificationNavigationManager: ObservableObject {
    @Published var navigationTarget: NotificationNavigationTarget? = nil

    func navigate(to target: NotificationNavigationTarget?) {
        DispatchQueue.main.async {
            self.navigationTarget = target
        }
    }

    func clear() {
        navigationTarget = nil
    }
}
