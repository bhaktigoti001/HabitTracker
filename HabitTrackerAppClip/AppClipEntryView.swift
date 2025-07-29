//
//  AppClipEntryView.swift
//  HabitTrackerAppClip
//
//  Created by DREAMWORLD on 29/07/25.
//

import SwiftUI
import CoreData

struct AppClipEntryView: View {
    @EnvironmentObject var viewModel: AppClipHabitViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Habit: \(viewModel.habit?.name ?? "Unknown")")
                .font(.title2)
                .bold()
            
            // You'll need to copy CircularProgressView to the App Clip target
            CircularProgressView(progress: viewModel.progressRatio)
                .frame(width: 100, height: 100)
            
            Button("Mark as Done") {
                viewModel.incrementProgress()
            }
            
            Button("Open Full App") {
                // Replace "habittracker" with your app's custom URL scheme
                // Ensure your main app is configured to handle this URL scheme
                UIApplication.shared.open(URL(string: "habittracker://habit/\(viewModel.habit?.id?.uuidString ?? "")")!)
            }
        }
        .padding()
    }
}
