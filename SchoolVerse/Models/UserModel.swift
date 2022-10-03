//
//  UserInfo.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/2/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var displayName: String
    var gradeLevel: Int
    var email: String
    
    var key: String
    var schedule: Schedule
    var courses: [Course]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case displayName = "display_name"
        case gradeLevel = "grade_level"
        case email
        
        case key = "private_key"
        case schedule
        case courses
    }
}
