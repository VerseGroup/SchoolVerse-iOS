//
//  Date+Distance.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/2/22.
//

import Foundation

extension Date {
    func calendarDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([component], from: calendar.startOfDay(for: self), to: calendar.startOfDay(for: date)).value(for: component)!
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
    
    func fallsBetween(start: Date, end: Date) -> Bool {
        (start...end).contains(self)
    }
    
    func sameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
}
