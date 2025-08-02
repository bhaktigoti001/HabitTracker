//
//  View+Extension.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 30/07/25.
//

import SwiftUI
import CoreData

extension View {
    func injectGlobalEnvironmentObjects(
        notificationManager: NotificationNavigationManager,
        appSettings: AppSettings,
        context: NSManagedObjectContext
    ) -> some View {
        self
            .environmentObject(notificationManager)
            .environmentObject(appSettings)
            .environment(\.managedObjectContext, context)
            .preferredColorScheme(appSettings.colorScheme)
    }
}
