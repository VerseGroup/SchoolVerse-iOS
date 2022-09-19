//
//  TabBarItem.swift
//  SchoolVerseTesting
//
//  Created by Steven Yu on 5/19/22.
//

import SwiftUI

enum TabBarItem: Hashable {
    case home, schedule, tasks, clubs, more
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .schedule: return "calendar"
        case .tasks: return "list.bullet.rectangle.portrait"
        case .clubs: return "person.2.fill"
        case .more: return "line.3.horizontal"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .schedule: return "Schedule"
        case .tasks: return "Tasks"
        case .clubs: return "Clubs"
        case .more: return "More"
        }
    }
}
