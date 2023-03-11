//
//  EventsView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct EventsView: View {
    @StateObject var vm: EventsListViewModel = EventsListViewModel()
    
    @State var showPicker: Bool = false
    
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    @Namespace var animation

    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                weekDateSelector
                
                Spacer()
                    .frame(height: 10)
                
                VStack(spacing: 20) {
                    if !vm.selectedEvents.isEmpty {
                        VStack {
                            Spacer()
                                .frame(height: 20)
                            
                            ScrollView(showsIndicators: false) {
                                ForEach(vm.selectedEvents) { event in
                                    EventCellView(event: event)
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                }
                                
                                Spacer()
                                    .frame(height: 95)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .heavyGlass()
                    } else {
                        VStack {
                            Spacer()
                                .frame(height: 20)
                            
                            Text("No Events Today!")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .heavyGlass()
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    showPicker = false
                }
            }
            // iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad) {
                GraphicalDatePicker(selectedDate: $vm.selectedDate, isPresented: $showPicker)
            }
        }
        .navigationTitle("Events")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button {
                    showPicker.toggle()
                } label: {
                    NavButtonView(systemName: "calendar")
                }
            })
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}

extension EventsView {
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
                        .opacity(day.hasSame(.day, as: vm.selectedDate) ? 1 : 0)
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
                        vm.updateSelectedDay(date: day)
                    }
                }
                
                Spacer()
            } //: ForEach
        } //: HStack
    }
}

extension EventsView {
    var dateSelector: some View {
        HStack {
            // go to previous day
            Button {
                withAnimation(.easeInOut) {
                    vm.updateSelectedDay(date: Calendar.current.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date())
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
                    vm.updateSelectedDay(date: Calendar.current.date(byAdding: .day, value: 1, to: vm.selectedDate) ?? Date())
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
