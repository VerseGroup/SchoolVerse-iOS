//
//  TabBarItem.swift
//  SchoolVerseTesting
//
//  Created by Steven Yu on 5/19/22.
//

import SwiftUI

enum TabBarItem: Hashable {
    case schedule, tasks, clubs, more, menu
    
    var iconName: String {
        switch self {
        case .menu: return "menucard.fill"
        case .schedule: return "calendar"
        case .tasks: return "list.bullet.rectangle.portrait"
        case .clubs: return "person.2.fill"
        case .more: return "line.3.horizontal"
        }
    }
    
    var title: String {
        switch self {
        case .menu: return "Menu"
        case .schedule: return "Schedule"
        case .tasks: return "Tasks"
        case .clubs: return "Clubs"
        case .more: return "More"
        }
    }
}
