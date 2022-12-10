//
//  Response.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import Foundation

struct VersionResponse: Codable {
    let iosVersion: String
    
    enum CodingKeys: String, CodingKey {
        case iosVersion = "ios_version"
    }
}

struct ApproveResponse: Codable {
    let message: ResponseMessage
    let exception: String?
    let approved: Bool?
}

struct GetDataResponse: Codable {
    let message: ResponseMessage
    let exception: String? // only happens when ResponseMessage.failure or .error
    let passed: Bool? // only happens when get data fails to pass
}

struct KeyResponse: Codable {
    let message: ResponseMessage
    let publicKey: String? // only happens when ResponseMessage.success
    let approved: Bool
    
    enum CodingKeys: String, CodingKey {
        case message
        case publicKey = "public_key"
        case approved
    }
}

struct EnsureResponse: Codable {
    let message: ResponseMessage
    let exception: String?
}


struct DeleteResponse: Codable {
    let message: ResponseMessage
    let exception: String?
}

enum ResponseMessage: String, Codable {
    case success
    case failure
    case error
    case overuse
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
            case .overuse:
                return "overuse"
            }
        }
    }
    
    static func getMessage(message: String) -> ResponseMessage {
        switch message {
        case "success":
            return .success
        case "user does not exist":
            return .failure
        case "overuse":
            return .overuse
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
