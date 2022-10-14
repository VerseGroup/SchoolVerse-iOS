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
    
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan

    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                dateSelector
                
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
        .navigationTitle("Events")
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
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
                    .frame(width: 75, height: 75)
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
                    .frame(width: 75, height: 75)
            }
            .foregroundColor(.white)
            .bold()
            .padding(5)
        }
        .padding()
    }
}
