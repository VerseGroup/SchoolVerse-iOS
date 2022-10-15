//
//  UserInfo.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/2/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// TODO: add subscribed sports model
struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var displayName: String
    var gradeLevel: Int
    var email: String
    
    var courses: [Course]
    
    var approved: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case displayName = "display_name"
        case gradeLevel = "grade_level"
        case email
        
        case courses
        
        case approved
    }
}
