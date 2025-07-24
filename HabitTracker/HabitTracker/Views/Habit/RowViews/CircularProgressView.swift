//
//  CircularProgressView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//


import SwiftUI

struct CircularProgressView: View {
    var progress: CGFloat // between 0 and 1
    var lineWidth: CGFloat = 10

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: progress)

            Text(String(format: "%.0f%%", progress * 100))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
    }
}
