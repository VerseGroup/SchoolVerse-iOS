//
//  String.swift
//  SchoolVerse
//
//  Created by dshola-philips on 11/30/22.
//

import Foundation
import SwiftUI

extension String {
    enum SportIcon: String, CaseIterable, Hashable {
        case soccer
        case football
        case fieldHockey
        case tennis
        case basketball
        case wrestling
        case squash
        case swimming
        case fencing
        case baseball
        case softball
        case lacrosse
        case golf
        case defaultSport
    }
    
    func checkSport() -> SportIcon {
        if self.contains("Soccer") {
            return .soccer
        } else if self.contains("Football") {
            return .football
        } else if self.contains("Field Hockey") {
            return .fieldHockey
        } else if self.contains("Tennis") {
            return .tennis
        } else if self.contains("Basketball") {
            return .basketball
        } else if self.contains("Wrestling") {
            return .wrestling
        } else if self.contains("Squash") {
            return .squash
        } else if self.contains("Swimming") {
            return .swimming
        } else if self.contains("Fencing") {
            return .fencing
        } else if self.contains("Baseball") {
            return .baseball
        } else if self.contains("Softball") {
            return .softball
        } else if self.contains("Lacrosse") {
            return .lacrosse
        } else if self.contains("Golf") {
            return .golf
        }
        
        return .defaultSport
    }
}
