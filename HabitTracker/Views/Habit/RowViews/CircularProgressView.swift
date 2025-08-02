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
    var progressColor: Color = .green
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var showPercentage: Bool = true
    var labelColor: Color = .primary

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                // Background Circle
                Circle()
                    .stroke(backgroundColor, lineWidth: lineWidth)

                // Progress Circle
                Circle()
                    .trim(from: 0, to: max(min(progress, 1.0), 0.0))
                    .stroke(
                        progressColor,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.interpolatingSpring(stiffness: 170, damping: 22), value: progress)

                // Center Text
                if showPercentage {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: size * 0.2, weight: .semibold, design: .rounded))
                        .foregroundColor(labelColor)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                }
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityLabel("Progress")
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}
