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
    var leaderNames: [String]
    var memberIds: [String]
    var memberNames: [String]
    
    var groupNotice: String
    var groupNoticeLastUpdated: Date
    var groupNoticeAuthor: String
    
    var status: Bool
    
    var clubEvents: [ClubEvent]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case leaderIds = "leader_ids"
        case leaderNames = "leader_names"
        case memberIds = "member_ids"
        case memberNames = "member_names"
        case groupNotice = "group_notice"
        case groupNoticeLastUpdated = "group_notice_last_updated"
        case groupNoticeAuthor = "group_notice_author"
        case status = "status"
        case clubEvents = "club_events"
    }
}

struct ClubEvent: Identifiable, Codable {
    var id: String
    var clubId: String

    var title: String
    var description: String
    
    var location: String

    var start: Date
    var end: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case clubId = "club_id"
        case title = "title"
        case description = "description"
        case location = "location"
        case start = "start"
        case end = "end"
    }
}
