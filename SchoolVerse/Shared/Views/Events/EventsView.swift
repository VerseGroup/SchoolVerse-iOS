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
            // if iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad){
                ColorfulBackgroundView()
            }
            
            // if ipad
            if UIDevice.current.userInterfaceIdiom == .pad {
                ClearBackgroundView()
            }
            
            VStack {
                
                WeeksTabView { week in
                    WeekView(week: week)
                }
                
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
                                
                                // if iphone
                                if !(UIDevice.current.userInterfaceIdiom == .pad){
                                    Spacer()
                                        .frame(height: 95)
                                }
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

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}

