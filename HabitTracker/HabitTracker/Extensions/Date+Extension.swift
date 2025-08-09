//
//  Date+Extension.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//

import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func formattedReminderTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func formattedLogDate(_ date: Date?) -> String {
        guard let date = date else { return "--" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func formattedLogDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy 'at' h:mm a"
        return formatter.string(from: self)
    }
    
    static func formattedWeekRange(startDate: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) ?? startDate
        let startString = formatter.string(from: startDate)
        let endString = formatter.string(from: endDate)

        let year = calendar.component(.year, from: startDate)

        return "\(startString) – \(endString), \(year)"
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = fromDate
        let calendar = Calendar.current
        
        while currentDate <= toDate {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
}
