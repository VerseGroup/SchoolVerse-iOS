//
//  Schedule.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/2/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// make sure to edit for next year's schedule
//struct Schedule: Codable, Identifiable {
//    @DocumentID var id: String?
//    var days: [DaySchedule] {
//        didSet {
//            days.sort()
//        }
//    }
//
//    var userId: String?
//
//    enum CodingKeys: String, CodingKey {
//        case days
//        case userId = "user_id"
//    }
//}

// TODO: add documentation
// TODO: adapt to new schedule

struct Schedule: Codable {
    var days: [DaySchedule] {
        didSet {
            days.sort()
        }
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
}

struct PeriodInfo: Codable, Comparable {
    var period: Period
    var className: String
    var startTime: String
    var endTime: String
    var information: String
    
    enum CodingKeys: String, CodingKey {
        case period
        case className = "class_name"
        case startTime = "start_time"
        case endTime = "end_time"
        case information
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
    case classPeriodOne
    case specialPeriod
    case classPeriodTwo
    case classPeriodThree
    case lunch
    case classPeriodFour
    case classPeriodFive
    
    case failed
}

// sorting functionality
// source: https://stackoverflow.com/questions/46864278/how-to-sort-objects-by-its-enum-value
extension Period {
    private var sortOrder: Int {
        switch self {
        case .homeroom:
            return 0
        case .classPeriodOne:
            return 1
        case .specialPeriod:
            return 2
        case .classPeriodTwo:
            return 3
        case .classPeriodThree:
            return 4
        case .lunch:
            return 5
        case .classPeriodFour:
            return 6
        case .classPeriodFive:
            return 7
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
            case .classPeriodOne:
                return "Class Period 1"
            case .specialPeriod:
                return "Special Period"
            case .classPeriodTwo:
                return "Class Period 2"
            case .classPeriodThree:
                return "Class Period 3"
            case .lunch:
                return "Lunch"
            case .classPeriodFour:
                return "Class Period 4"
            case .classPeriodFive:
                return "Class Period 5"
            case .failed:
                return "Failed"
            }
        }
    }
    
    static func getPeriod(period: String) -> Period {
        switch period {
        case "Homeroom":
            return .homeroom
        case "Class Period 1":
            return .classPeriodOne
        case "Special Period": // refactor for later (accomodate all special periods)
            return .specialPeriod
        case "Class Period 2":
            return .classPeriodTwo
        case "Class Period 3":
            return .classPeriodThree
        case "Lunch":
            return .lunch
        case "Class Period 4":
            return .classPeriodFour
        case "Class Period 5":
            return .classPeriodFive
        default:
            return .failed
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = Period.getPeriod(period: rawValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}
