//
//  ScheduleView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/9/22.
//

import SwiftUI

// TODO: figure out transitions
struct ScheduleView: View {
    @StateObject var vm = ScheduleViewModel()
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                if let _ = vm.schedule {
                    HStack {
                        // go to previous day
                        Button {
                            withAnimation(.easeInOut) {
                                vm.updateSelectedDayEvent(date: Calendar.current.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date())
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundColor(.white)
                        .padding(2)
                        
                        Spacer()
                        
                        if let day = vm.selectedDayEvent {
                            DayScheduleTile(day: day)
                        } else {
                            Text(vm.selectedDate.weekDateString())
                                .fontWeight(.semibold)
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .glassCardFull()
                        }
                        
                        Spacer()
                        
                        // go to next day
                        Button {
                            withAnimation {
                                vm.updateSelectedDayEvent(date: Calendar.current.date(byAdding: .day, value: 1, to: vm.selectedDate) ?? Date())
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding(2)
                    }
                    .padding()
                    
                    if let day = vm.selectedDayEvent {
                        ScrollView(showsIndicators: false) {
                            // day schedule portion
                            if let daySchedule = vm.schedule?.days.first(where: { daySchedule in
                                day.day == daySchedule.day
                            }) {
                                // ensures ForEach works since PeriodInfo is not unique, but ForEach requires unique
                                ForEach(
                                    // converting PeriodInfo to UniquePeriodInfo
                                    daySchedule.periods.compactMap({ period in
                                        UniquePeriodInfo(period: period)
                                    }).sorted(by: { one, two in
                                        one.period < two.period
                                    })
                                ) { uniquePeriod in
                                    PeriodTileAndHeader(periodInfo: uniquePeriod.period)
                                }
                            }
                            
                            Spacer()
                                .frame(height: 90)
                        }
                        .transition(.opacity)
                    } else {
                        VStack {
                            Spacer()
                            Text("No Classes Today!")
                                .fontWeight(.semibold)
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                            Spacer()
                            Spacer()
                        }
                        .transition(.opacity)
                    }
                    
                } else {
                    Text("Schedule unavailable")
                }
            }
        }
        .navigationTitle("Schedule")
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
