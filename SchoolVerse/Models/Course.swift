//
//  Course.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/2/22.
//

import Foundation
import SwiftUI

struct Course: Codable, Hashable {
    var id: String
    var name: String
    var section: String
}
