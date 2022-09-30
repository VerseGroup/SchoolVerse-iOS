//
//  Response.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import Foundation

struct ScrapeResponse: Codable {
    let message: ResponseMessage
    let exception: String? // only happens when ResponseMessage.failure
}

struct KeyResponse: Codable {
    let message: ResponseMessage
    let publicKey: String? // only happens when ResponseMessage.success
    
    enum CodingKeys: String, CodingKey {
        case message
        case publicKey = "public_key"
    }
}

struct EnsureResponse: Codable {
    let message: ResponseMessage
}

enum ResponseMessage: String, Codable {
    case success
    case failure
    case error
}

// codable functionality
extension ResponseMessage {
    var description: String {
        get {
            switch self {
            case .success:
                return "success"
            case .failure:
                return "Failure"
            case .error:
                return "error"
            }
        }
    }
    
    static func getMessage(message: String) -> ResponseMessage {
        switch message {
        case "success":
            return .success
        case "failed to scrape schoology":
            return .failure
        case "user does not exist":
            return .failure
        default:
            return .error
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = ResponseMessage.getMessage(message: rawValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}
