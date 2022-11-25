//
//  SportsView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct SportsView: View {
    @StateObject var vm: SportsListViewModel = SportsListViewModel()
    
    @State var showPicker: Bool = false
    @State var allSportsSort: Bool = true
    
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                dateSelector
                
                VStack(spacing: 20) {
                    if !vm.selectedAllSportsEvents.isEmpty {
                        
                        if allSportsSort {
                            VStack {
                                Spacer()
                                    .frame(height: 20)
                                
                                Text("All Sports")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                ScrollView(showsIndicators: false) {
                                    ForEach(vm.selectedAllSportsEvents) { sportEvent in
                                        SportsEventCellView(sportsEvent: sportEvent)
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
                                
                                Text("My Sports")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                ScrollView(showsIndicators: false) {
                                    ForEach(vm.selectedAllSportsEvents) { sportEvent in
                                        SportsEventCellView(sportsEvent: sportEvent)
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                    }
                                    
                                    Spacer()
                                        .frame(height: 95)
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .heavyGlass()
                        }
                    } else {
                        VStack {
                            Spacer()
                                .frame(height: 20)
                            
                            Text("No Sports Events Today!")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
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
        .navigationTitle("Sports")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                Button {
                    showPicker.toggle()
                } label: {
                    NavButtonView(systemName: "calendar")
                }
                
                Menu {
                    Picker(selection: $allSportsSort, label: Text("Sorting options")) {
                        Text("All Sports").tag(true)
                        Text("My Sports").tag(false)
                    }
                } label: {
                    NavButtonView(systemName: "line.3.horizontal.decrease")
                }
            })
        }
    }
}

struct SportsView_Previews: PreviewProvider {
    static var previews: some View {
        SportsView()
    }
}

extension SportsView {
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
