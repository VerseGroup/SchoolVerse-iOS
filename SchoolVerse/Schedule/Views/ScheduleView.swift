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
    
    @State var showPicker: Bool = false
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                if let _ = vm.schedule {
                    dateSelector
                    
                    VStack(spacing: 0) {
                        if let day = vm.selectedDayEvent {
                            ScrollView(showsIndicators: false) {
                                DayScheduleTile(day: day)
                                
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
                    }
                    .frame(maxWidth: .infinity)
                    //                    .background {
                    //                        if showPicker {
                    //                            Color.black.opacity(0.5)
                    //                                .blur(radius: 50)
                    //                        }
                    //                    }
                    
                } else {
                    Text("Schedule unavailable")
                }
            }
            .onTapGesture {
                withAnimation {
                    showPicker = false
                }
            }
            
            DatePicker("", selection: $vm.selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .tint(accentColor)
                .frame(width: 310, height: 300)
                .clipped()
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 25, style: .continuous)
                )
                .opacity(showPicker ? 1 : 0 )
                .offset(x: 0, y: -100)
                .onChange(of: vm.selectedDate) { _ in
                    withAnimation {
                        showPicker = false
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

extension ScheduleView {
    var dateSelector: some View {
        HStack {
            // go to previous day
            Button {
                withAnimation(.easeInOut) {
                    vm.updateSelectedDayEvent(date: Calendar.current.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date())
                }
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 50, height: 50)
            }
            .foregroundColor(.white)
            .bold()
            .padding(5)
            
            Spacer()
            
            Button {
                withAnimation {
                    showPicker.toggle()
                }
            }  label: {
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
                    .frame(width: 50, height: 50)
            }
            .foregroundColor(.white)
            .bold()
            .padding(5)
        }
        .padding()
    }
}
