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
            weekDateSelector
            
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
                            
                            Spacer()
                                .frame(height: 95)
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
        }
        .onAppear {
            vm.updateSelectedDay(date: vm.selectedDate) // updates the date to force reload the selected events
        }
    }
}

extension ClubsCalendarView {
    var weekDateSelector: some View {
        HStack {
            Spacer()
            
            ForEach(vm.selectedWeek, id: \.self) { day in
                VStack(spacing: 10) {
                    Text(day.dateNumberString())
                        .fontWeight(.semibold)
                    
                    Text(day.weekDayString())
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 8)
                        .opacity(day.hasSame(.day, as: Date.now) ? 1 : 0)
                }
                .foregroundColor(Color.white)
                .frame(width: 45, height: 95)
                .background(
                    ZStack{
                        if day.hasSame(.day, as: vm.selectedDate) {
                            Capsule()
                                .fill(.clear)
                                .taintedGlass()
                                .matchedGeometryEffect(id: "currentday", in: animation)
                        }
                    }
                )
                .onTapGesture {
                    withAnimation {
                        vm.updateSelectedDay(date: day) // change
                    }
                }
                
                Spacer()
            } //: ForEach
        } //: HStack
    }
    
    var scrollingDateSelector: some View {
        TabView {
            ForEach(0..<3) {_ in
                weekDateSelector
            }
        }
        .frame(height: UIScreen.main.bounds.height / 8)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
    }
}
