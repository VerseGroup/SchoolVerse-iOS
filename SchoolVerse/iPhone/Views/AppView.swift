//
//  AppView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/19/22.
//

import SwiftUI
import Resolver

// TODO: pop to root of navstack when clicking tab bar icon
struct AppView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager
    
    @State var selection: TabBarItem = .schedule
    let tabs: [TabBarItem] = [.schedule, .tasks, .menu, .clubs, .more]
    
    var body: some View {
        TabBarViewBuilder {
            NavigationStack {
                ScheduleView()
            }
            .tabBarItem(tab: TabBarItem.schedule, selection: selection)
            
            NavigationStack {
                TasksView()
            }
            .tabBarItem(tab: TabBarItem.tasks, selection: selection)
            
            NavigationStack {
                MenusView()
            }
            .tabBarItem(tab: TabBarItem.menu, selection: selection)
            
            NavigationStack {
                ClubsView()
            }
            .tabBarItem(tab: TabBarItem.clubs, selection: selection)
            
            NavigationStack {
                MoreView(selection: $selection)
            }
            .tabBarItem(tab: TabBarItem.more, selection: selection)
            
        } tabBar: {
            TabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        }
        .preferredColorScheme(.dark)
    }
}

//struct AppView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppView()
//    }
//}
