//
//  HabitTrackerAppClip.swift
//  HabitTrackerAppClip
//
//  Created by DREAMWORLD on 29/07/25.
//

import SwiftUI

@main
struct HabitTrackerAppClip: App {
    let persistenceController = AppClipPersistence.shared

    @StateObject private var viewModel = AppClipHabitViewModel(
        context: AppClipPersistence.shared.container.viewContext
    )
    
    var body: some Scene {
        WindowGroup {
            AppClipEntryView()
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    if let url = activity.webpageURL, let uuid = UUID(uuidString: "41044AF8-672C-491C-B371-CE8274FBEFFA") {
                        viewModel.loadHabit(by: uuid) // e.g., habitId param
                    }
                }
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
