//
//  DayPeriod.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/15/23.
//

import Foundation

struct DayPeriod: Codable {
    let day: Day
    let period: Period
}

extension DayPeriod {
    var description: String {
        get {
            var result: String = ""
            
            switch self.day {
            case .dayOne:
                result += "Day 1"
            case .dayTwo:
                result += "Day 2"
            case .dayThree:
                result += "Day 3"
            case .dayFour:
                result += "Day 4"
            case .dayFive:
                result += "Day 5"
            case .daySix:
                result += "Day 6"
            case .daySeven:
                result += "Day 7"
            case .dayEight:
                result += "Day 8"
            case .failed:
                return "Failed"
            }
            
            result += ";"
            
            switch self.period {
            case .homeroom:
                result += "Homeroom"
            case .periodOne:
                result += "Period 1"
            case .communityTime:
                result += "Community Time"
            case .periodTwo:
                result += "Period 2"
            case .periodThree:
                result += "Period 3"
            case .lunchOne:
                result += "First Lunch"
            case .lunchTwo:
                result += "Second Lunch"
            case .periodFour:
                result += "Period 4"
            case .periodFive:
                result += "Period 5"
            case .failed:
                result += "Failed"
            }
            
            return result
        }
    }
    
    static func getDayPeriod(dayPeriod: String) -> DayPeriod {
        let dayToken = dayPeriod.components(separatedBy: ";")[0]
        let periodToken = dayPeriod.components(separatedBy: ";")[1]
        
        return DayPeriod(day: Day(day: dayToken), period: Period(period: periodToken))
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = DayPeriod.getDayPeriod(dayPeriod: rawValue)
    }
    
    init(dayPeriod: String) {
        self = DayPeriod.getDayPeriod(dayPeriod: dayPeriod)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}
