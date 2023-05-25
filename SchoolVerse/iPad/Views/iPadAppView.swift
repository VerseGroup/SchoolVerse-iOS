//
//  iPadAppView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 5/21/23.
//

import SwiftUI

struct iPadAppView: View {
    @State var selection: SideBarItem = .schedule
    let tabs: [SideBarItem] = [.schedule, .tasks, .menus, .clubs, .sports, .events, .settings, .about]
    
    var body: some View {
        NavigationStack {
            ZStack {
                iPadColorfulBackgroundView()
                
                SideBarViewBuilder {
                    
                    ScheduleView()
                        .sideBarItem(tab: SideBarItem.schedule, selection: selection)
                    
                    TasksView()
                        .sideBarItem(tab: SideBarItem.tasks, selection: selection)
                    
                    MenusView()
                        .sideBarItem(tab: SideBarItem.menus, selection: selection)
                    
                    //NavigationStack {
                    ClubsView()
                    //}
                        .sideBarItem(tab: SideBarItem.clubs, selection: selection)
                    
                    SportsView()
                        .sideBarItem(tab: SideBarItem.sports, selection: selection)
                    
                    EventsView()
                        .sideBarItem(tab: SideBarItem.events, selection: selection)
                    
                    SettingsView()
                        .sideBarItem(tab: SideBarItem.settings, selection: selection)
                    
                    AboutView()
                        .sideBarItem(tab: SideBarItem.about, selection: selection)
                    
                } sideBar: {
                    SideBarView(tabs: tabs, selection: $selection, localSelection: selection)
                }
            }
        }
        .toolbar(.hidden)
        .preferredColorScheme(.dark)
    }
}


//struct iPadAppView_Previews: PreviewProvider {
//    static var previews: some View {
//        iPadAppView()
//    }
//}
