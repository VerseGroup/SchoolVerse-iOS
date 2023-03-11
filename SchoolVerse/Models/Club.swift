//
//  Club.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/7/23.
//

import Foundation

struct Club: Identifiable {
    var id: String
    
    var name: String
    var description: String
    
    var leaders: [UserModel]
    var members: [UserModel]
    
    var meetingBlocks: [Date]
    var announcement: String
    //var updates: [ClubUpdate]
    var events: [Date]
}

//struct ClubUpdate: Identifiable {
//    var id: String
//    var clubId: String
//
//    var title: String
//    var description: String
//
//    var club: Club
//    var datePosted: Date
//}

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
