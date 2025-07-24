//
//  DailyLog.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//


import Foundation

struct DailyLog: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
