//
//  Course.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/2/22.
//

import Foundation
import SwiftUI

struct Coursework: Codable {
    var courses: [Course]
}

struct Course: Codable {
    var id: String
    var name: String
    var color: String // TODO: change to Color or UIColor
}
