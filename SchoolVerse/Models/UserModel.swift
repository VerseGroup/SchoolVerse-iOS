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
    
    var creds: CredentialsModel
    var schedule: Schedule
    var coursework: Coursework
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case displayName = "display_name"
        
        case creds
        case schedule
        case coursework
    }
}
