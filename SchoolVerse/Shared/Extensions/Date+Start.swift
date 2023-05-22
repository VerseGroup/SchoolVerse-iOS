//
//  Date+Start.swift
//  SchoolVerse
//
//  Created by Steven Yu on 12/12/22.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
