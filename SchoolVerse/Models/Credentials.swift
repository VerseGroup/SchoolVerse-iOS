//
//  Credentials.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/2/22.
//

import Foundation

struct CredentialsDetails: Codable {
    var username: String
    var password: String
}

struct CredentialsModel: Codable {
    var veracross: CredentialsDetails?
    var schoology: CredentialsDetails?
    
    enum CodingKeys: String, CodingKey {
        case veracross = "vc"
        case schoology = "sc"
    }
}
