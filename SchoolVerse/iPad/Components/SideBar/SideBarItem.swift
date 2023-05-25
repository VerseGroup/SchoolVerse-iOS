//
//  SideBarItem.swift
//  SchoolVerse
//
//  Created by dshola-philips on 5/21/23.
//

import SwiftUI

enum SideBarItem: Hashable {
    case schedule, tasks, menus, clubs, sports, events, settings, about
    
    var iconName: String {
        switch self {
        case .schedule: return "calendar"
        case .tasks: return "list.bullet.rectangle.portrait"
        case .menus: return "menucard.fill"
        case .clubs: return "person.3.fill"
        case .sports: return "sportscourt"
        case .events: return "calendar.badge.exclamationmark"
        case .settings: return "gear"
        case .about: return "info.circle.fill"

        }
    }
    
    var title: String {
        switch self {
        case .schedule: return "Schedule"
        case .tasks: return "Tasks"
        case .menus: return "Menus"
        case .clubs: return "Clubs"
        case .sports: return "Sports"
        case .events: return "Events"
        case .settings: return "Settings"
        case .about: return "About"
        }
    }
}
