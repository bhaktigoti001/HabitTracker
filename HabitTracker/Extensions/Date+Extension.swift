//
//  Date+Extension.swift
//  HabitTracker
//
//  Created by DREAMWORLD on 24/07/25.
//

import Foundation

extension Date {
    var timezoneDate: Date {
        let seconds = TimeZone.current.secondsFromGMT(for: self)
        return addingTimeInterval(TimeInterval(seconds))
    }
    
    var startOfDay: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self)
    }
    
    var startOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: sunday)
    }
    
    var endOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone.current
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)
    }
    
    func formattedReminderTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func formattedLogDate(_ date: Date?) -> String {
        guard let date = date else { return "--" }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func formattedLogDate() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd MMM yyyy 'at' h:mm a"
        return formatter.string(from: self)
    }
    
    static func formattedWeekRange(startDate: Date) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
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
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        while currentDate <= toDate {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
}
