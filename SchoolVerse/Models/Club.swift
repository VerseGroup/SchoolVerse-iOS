//
//  Club.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/7/23.
//

import Foundation

struct Club: Identifiable, Codable {
    var id: String
    
    var name: String
    var description: String
    
    var leaderIds: [String]
    var memberIds: [String]
    
    var meetingBlocks: [DayPeriod] // Format: "Day 1;Period 1"
    var meetingBlockStyle: String
    var groupNotice: String
    var status: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case leaderIds = "leader_ids"
        case memberIds = "member_ids"
        case meetingBlocks = "meeting_blocks"
        case meetingBlockStyle = "meeting_block_style"
        case groupNotice = "group_notice"
        case status = "status"
    }
}

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



// legacy code below
struct ClubMeeting: Identifiable {
    var id: String
    var clubId: String
    
    var title: String
    var description: String
    
    var date: Date
    var location: String
    var time: String
}

struct ClubEvent: Identifiable {
    var id: String
    var clubId: String
    
    var title: String
    var description: String
    
    var date: Date
    var location: String
    var time: String
    
    var meetingBlock: Date
}
