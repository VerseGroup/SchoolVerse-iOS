//
//  Schedule.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/2/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// TODO: edit when paul fixes "special" case bug
struct Schedule: Codable, Identifiable {
    @DocumentID var id: String?
    
    var days: [DaySchedule] {
        didSet {
            days.sort()
        }
    }
    
    var userId: String?
    
    enum CodingKeys: String, CodingKey {
        case days
        case userId = "user_id"
    }
}

struct DaySchedule: Codable, Comparable {
    var day: Day
    var periods: [PeriodInfo] {
        didSet {
            periods.sort()
        }
    }
    
    static func ==(lhs: DaySchedule, rhs: DaySchedule) -> Bool {
        return lhs.day == rhs.day
    }
    
    static func <(lhs: DaySchedule, rhs: DaySchedule) -> Bool {
        return lhs.day < rhs.day
    }
}

// to ensure ForEach loop works
struct UniquePeriodInfo: Identifiable {
    var id = UUID()
    var period: PeriodInfo
    var startDate: Date
    var endDate: Date
    
    init(period: PeriodInfo, date: Date) {
        self.period = period
        let startDateString = date.shortDateString() + " " + period.startTime
        let endDateString = date.shortDateString() + " " + period.endTime
        self.startDate = startDateString.convertToDate() ?? Date.now
        self.endDate = endDateString.convertToDate() ?? Date.now
    }
}

struct PeriodInfo: Codable, Comparable {
    var period: Period
    var course: CourseInfo
    var startTime: String
    var endTime: String
    
    enum CodingKeys: String, CodingKey {
        case period
        case course
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

struct CourseInfo: Codable {
    var name: String
    var teacher: String
//    var room: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case teacher
//        case room
    }
}

// comparable functionality
extension PeriodInfo {
    static func ==(lhs: PeriodInfo, rhs: PeriodInfo) -> Bool {
        return lhs.period == rhs.period
    }
    
    static func <(lhs: PeriodInfo, rhs: PeriodInfo) -> Bool {
        return lhs.period < rhs.period
    }
}

enum Period: String, Codable, Comparable {
    case homeroom
    case periodOne
    case communityTime
    case periodTwo
    case periodThree
    case lunchOne
    case lunchTwo
    case periodFour
    case periodFive
    
    case failed
}

// sorting functionality
// source: https://stackoverflow.com/questions/46864278/how-to-sort-objects-by-its-enum-value
extension Period {
    private var sortOrder: Int {
        switch self {
        case .homeroom:
            return 0
        case .periodOne:
            return 1
        case .communityTime:
            return 2
        case .periodTwo:
            return 3
        case .periodThree:
            return 4
        case .lunchOne:
            return 5
        case .lunchTwo:
            return 6
        case .periodFour:
            return 7
        case .periodFive:
            return 8
        case .failed:
            return -1
        }
    }
    
    static func ==(lhs: Period, rhs: Period) -> Bool {
        return lhs.sortOrder == rhs.sortOrder
    }
    
    static func <(lhs: Period, rhs: Period) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
}


// codable functionality
// source: https://levelup.gitconnected.com/firestore-to-swift-models-with-complex-types-enums-and-arrays-282893affb15
extension Period {
    var description: String {
        get {
            switch self {
            case .homeroom:
                return "Homeroom"
            case .periodOne:
                return "Period 1"
            case .communityTime:
                return "Community Time"
            case .periodTwo:
                return "Period 2"
            case .periodThree:
                return "Period 3"
            case .lunchOne:
                return "First Lunch"
            case .lunchTwo:
                return "Second Lunch"
            case .periodFour:
                return "Period 4"
            case .periodFive:
                return "Period 5"
            case .failed:
                return "Failed"
            }
        }
    }
    
    static func getPeriod(period: String) -> Period {
        switch period {
        case "Homeroom":
            return .homeroom
        case "Period 1":
            return .periodOne
        case "Special":
            return .communityTime
        case "Period 2":
            return .periodTwo
        case "Period 3":
            return .periodThree
        case "First Lunch":
            return .lunchOne
        case "Second Lunch":
            return .lunchTwo
        case "Period 4":
            return .periodFour
        case "Period 5":
            return .periodFive
        default:
            return .failed
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Period.getPeriod(period: rawValue)
    }
    
    init(period: String) {
        self = Period.getPeriod(period: period)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}
