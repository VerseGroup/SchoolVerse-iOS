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

struct SportsEvent: Codable, Identifiable {
    var id: String // custom id, not Firebase generated @DocumentID
    var summary: String
    var description: String
    var location: String
    var start: Date
    var end: Date?
}

struct Sport: Codable, Identifiable {
    var id: String // custom id, not Firebase generated @DocumentID
    var name: String
    var link: String
    var events: [SportsEvent]
}
