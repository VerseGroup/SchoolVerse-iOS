//
//  Event.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation

struct Event: Codable, Identifiable {
    var id: String // custom id, not Firebase generated @DocumentID
    var summary: String // title/name, most important
    var description: String
    var location: String
    var start: Date?
    var end: Date?
    var day: Date
}

// change model later
struct SportsEvent: Codable, Identifiable {
    var id: String // custom id, not Firebase generated @DocumentID
    var description: String
    var location: String?
    var start: Date
    var end: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case start = "start_date"
        case end = "end_date"
    }
}
