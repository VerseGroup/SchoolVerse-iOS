//
//  ClubsCalendarView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/16/23.
//

import SwiftUI

struct ClubsCalendarView: View {
    @EnvironmentObject var vm: ClubsViewModel
    
    @Namespace var animation
    
    var body: some View {
        Group {
            
            WeeksTabView { week in
                WeekView(week: week)
            }
            
            Spacer()
                .frame(height: 10)
            
            VStack(spacing: 20) {
                if !vm.selectedJoinedClubsEvents.isEmpty {
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(vm.selectedJoinedClubsEvents) { clubEvent in
                                ClubCalendarEventTile(clubEvent: clubEvent)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                            }
                            
                            // if iphone
                            if !(UIDevice.current.userInterfaceIdiom == .pad){
                                Spacer()
                                    .frame(height: 95)
                            }
                        }

                    }
                } else {
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        
                        Text("No Club Events Today!")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .heavyGlass()
            
            // if ipad
            if (UIDevice.current.userInterfaceIdiom == .pad){
                Spacer()
                    .frame(height: 16)
            }
        }
        .onAppear {
            vm.weekStore.select(date: vm.weekStore.selectedDate) // updates the date to force reload the selected events
        }
    }
}

