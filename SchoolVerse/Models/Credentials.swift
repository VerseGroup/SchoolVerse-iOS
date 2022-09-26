//
//  Credentials.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/2/22.
//

import Foundation

struct AppCredentialsDetails {
    var email: String
    var password: String
}

struct CredentialsDetails: Codable {
    var username: String
    var password: String
}
