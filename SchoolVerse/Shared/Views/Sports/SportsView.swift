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
    @AppStorage("app_sports_sort") var allSportsSort: Bool = true
    
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
                    if !vm.selectedAllSportsEvents.isEmpty {
                        if allSportsSort {
                            AllSportsView()
                        } else {
                            MySportsView()
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
                        Text("All Sports").tag(true as Bool) // just to make sure
                        Text("My Sports").tag(false as Bool) // just to make sure
                    }
                } label: {
                    NavButtonView(systemName: "line.3.horizontal.decrease")
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
        .environmentObject(vm)
        .environmentObject(vm.weekStore)
    }
}

struct SportsView_Previews: PreviewProvider {
    static var previews: some View {
        SportsView()
    }
}
