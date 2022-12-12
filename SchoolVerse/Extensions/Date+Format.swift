//
//  Date+Format.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import Foundation

extension Date {
    private var weekDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, h:mm a"
        return formatter
    }
    
    func weekDateTimeString() -> String {
        return weekDateTimeFormatter.string(from: self)
    }
    
    private var weekDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }
    
    func weekDateString() -> String {
        return weekDateFormatter.string(from: self)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    func timeString() -> String {
        return timeFormatter.string(from: self)
    }
    
    private var dateNumberFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }
    
    func dateNumberString() -> String {
        return dateNumberFormatter.string(from: self)
    }
    
    private var weekDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }
    
    func weekDayString() -> String {
        return weekDayFormatter.string(from: self)
    }
    
    private var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    func shortDateString() -> String {
        return shortDateFormatter.string(from: self)
    }
}
