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
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            // if iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad){
                ColorfulBackgroundView()
            }
            
            // if ipad
            if UIDevice.current.userInterfaceIdiom == .pad {
                ClearBackgroundView()
            }
            
            VStack {
                if let _ = vm.schedule {
                    
                    WeeksTabView { week in
                        WeekView(week: week)
                    }
                    
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
                                            UniquePeriodInfo(period: period, date: day.date)
                                        }).sorted(by: { one, two in
                                            one.period < two.period
                                        })
                                    ) { uniquePeriod in
                                        if Date.now.fallsBetween(start: uniquePeriod.startDate, end: uniquePeriod.endDate) {
                                            CurrentPeriodTileAndHeader(periodInfo: uniquePeriod.period)
                                        } else {
                                            PeriodTileAndHeader(periodInfo: uniquePeriod.period)
                                        }
                                    }
                                }
                                
                                // if iphone
                                if !(UIDevice.current.userInterfaceIdiom == .pad){
                                    Spacer()
                                        .frame(height: 95)
                                }
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
                    LoadingView(text: "Getting Schedule")
                }
                
                // if ipad
                if (UIDevice.current.userInterfaceIdiom == .pad){
                    Spacer()
                        .frame(height: 16)
                }
            }
            .onTapGesture {
                withAnimation {
                    showPicker = false
                }
            }
        }
        .navigationTitle("Schedule")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button {
                    showPicker.toggle()
                } label: {
                    NavButtonView(systemName: "calendar")
                }
            })
        }
        .sheet(isPresented: $showPicker) {
            ZStack {
                if(UIDevice.current.userInterfaceIdiom == .pad) {
                    ClearBackgroundView()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            showPicker.toggle()
                        }
                }
                
                GraphicalDatePicker(selectedDate: $vm.weekStore.selectedDate, isPresented: $showPicker)
            }
            .presentationDetents([.medium])
        }
        .environmentObject(vm.weekStore)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

extension ScheduleView {
//    var weekDateSelector: some View {
//        HStack {
//            Spacer()
//
//            ForEach(vm.selectedWeek, id: \.self) { day in
//                VStack(spacing: 10) {
//                    Text(day.dateNumberString())
//                        .fontWeight(.semibold)
//
//                    Text(day.weekDayString())
//                        .font(.system(size: 14))
//                        .fontWeight(.semibold)
//
//                    Circle()
//                        .fill(.white)
//                        .frame(width: 8)
//                        .opacity(day.hasSame(.day, as: Date.now) ? 1 : 0)
//                }
//                .foregroundColor(Color.white)
//                .frame(width: 45, height: 95)
//                .background(
//                    ZStack{
//                        if day.hasSame(.day, as: vm.selectedDate) {
//                            Capsule()
//                                .fill(.clear)
//                                .taintedGlass()
//                                .matchedGeometryEffect(id: "currentday", in: animation)
//                        }
//                    }
//                )
//                .onTapGesture {
//                    withAnimation {
//                        vm.updateSelectedDayEvent(date: day)
//                    }
//                }
//
//                Spacer()
//            } //: ForEach
//        } //: HStack
//    }
}

//extension ScheduleView {
//    var dateSelector: some View {
//        HStack {
//            // go to previous day
//            Button {
//                withAnimation(.easeInOut) {
//                    vm.updateSelectedDayEvent(date: Calendar.current.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date())
//                }
//            } label: {
//                Image(systemName: "chevron.left")
//                    .frame(width: 50, height: 50)
//            }
//            .foregroundColor(.white)
//            .bold()
//            .padding(5)
//            
//            Spacer()
//            
//            Button {
//                withAnimation {
//                    showPicker.toggle()
//                }
//            }  label: {
//                Text(vm.selectedDate.weekDateString())
//                    .fontWeight(.semibold)
//                    .font(.headline)
//                    .foregroundColor(Color.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .glassCardFull()
//            }
//            
//            Spacer()
//            
//            // go to next day
//            Button {
//                withAnimation {
//                    vm.updateSelectedDayEvent(date: Calendar.current.date(byAdding: .day, value: 1, to: vm.selectedDate) ?? Date())
//                }
//            } label: {
//                Image(systemName: "chevron.right")
//                    .frame(width: 50, height: 50)
//            }
//            .foregroundColor(.white)
//            .bold()
//            .padding(5)
//        }
//        .padding()
//    }
//}
