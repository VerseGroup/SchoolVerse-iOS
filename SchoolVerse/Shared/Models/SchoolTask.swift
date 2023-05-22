//
//  SchoolTask.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// TODO: Add colors, group courses together (probably make course a struct)

struct PlatformInformation: Codable {
    var assignmentCode: String
    var platformCode: String

    enum CodingKeys: String, CodingKey {
        case assignmentCode = "assignment_code"
        case platformCode = "platform_code"
    }
}

struct SchoolTask: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var completed: Bool
    var dueDate: Date
    var description: String
    
    var courseId: String
    var courseName: String
    
//    var numAccessed: Int
    
    var platformInformation: PlatformInformation
//    var userId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case completed
        case dueDate = "due_date"
        case description
        
        case courseId = "course_id"
        case courseName = "course_name"
        
//        case numAccessed = "num_accessed"
        
        case platformInformation = "platform_information"
//        case userId = "user_id"
    }
}
