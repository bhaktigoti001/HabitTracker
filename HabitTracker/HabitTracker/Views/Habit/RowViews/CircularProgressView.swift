//
//  CircularProgressView.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//


import SwiftUI

struct CircularProgressView: View {
    var progress: CGFloat
    var lineWidth: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.4), value: progress)

                Text(String(format: "%.0f%%", progress * 100))
                    .font(.system(size: size * 0.2, weight: .bold))
                    .foregroundColor(.blue)
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
