//
//  ClubsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/7/23.
//

import SwiftUI

enum ClubPages: String, CaseIterable, Hashable {
    case directory = "Directory"
    case calendar = "Calendar"
}

struct ClubsView: View {
    @StateObject var vm: ClubsViewModel = ClubsViewModel()
    
    @State var selectedPage: ClubPages = .directory
    @State var showPicker: Bool = false
    
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @Namespace var animation
    
    var body: some View {
        ZStack {
            // if iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad){
                ColorfulBackgroundView()
            }
            
            VStack {
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    iPadNavButtons
                }
                
                Spacer()
                    .frame(height: 15)
                
                if !(UIDevice.current.userInterfaceIdiom == .pad){
                    
                    // DSP: switch - put into own component
                    HStack (spacing: 20) {
                        ForEach (ClubPages.allCases, id: \.self) { page in
                            Text(page.rawValue)
                                .fontWeight(.semibold)
                                .font(.headline)
                                .frame(width: UIScreen.main.bounds.width / 3)
                                .background (
                                    ZStack {
                                        if page == selectedPage {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.clear)
                                                .padding(20)
                                                .taintedGlass()
                                                .matchedGeometryEffect(id: "currentPage", in: animation)
                                        } //: if
                                    } //: Zstack
                                ) //: background
                                .onTapGesture {
                                    withAnimation {
                                        selectedPage = page
                                    }
                                }
                        } //: ForEach
                    } //: HStack
                    .padding(.vertical, 15)
                    .padding(.horizontal, 5)
                    .cornerRadius(20)
                    .heavyGlass()
                    .padding(.bottom)
                    
                } else {
                    
                    HStack (spacing: 20) {
                        ForEach (ClubPages.allCases, id: \.self) { page in
                            Text(page.rawValue)
                                .fontWeight(.semibold)
                                .font(.headline)
                                .frame(width: UIScreen.main.bounds.width / 4.5)
                                .background (
                                    ZStack {
                                        if page == selectedPage {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.clear)
                                                .padding(20)
                                                .taintedGlass()
                                                .matchedGeometryEffect(id: "currentPage", in: animation)
                                        } //: if
                                    } //: Zstack
                                ) //: background
                                .onTapGesture {
                                    withAnimation {
                                        selectedPage = page
                                    }
                                }
                        } //: ForEach
                    } //: HStack
                    .padding(.vertical, 15)
                    .padding(.horizontal, 5)
                    .cornerRadius(20)
                    .heavyGlass()
                    .padding(.bottom)
                    
                }
                    
                switch selectedPage {
                case .directory:
                    ClubsDirectoryView()
                case .calendar:
                    ClubsCalendarView()
                }
            }
            .alert("Error", isPresented: $vm.hasError, actions: {
                Button("OK", role: .cancel) { }
            }) {
                Text(vm.errorMessage ?? "")
            }
            
            // iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad) {
                    GraphicalDatePicker(selectedDate: $vm.selectedDate, isPresented: $showPicker)
            }
        }
        .if(!(UIDevice.current.userInterfaceIdiom == .pad)) { view in
            view
                .navigationTitle("Clubs")
                .toolbar {
                    if selectedPage == .calendar {
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
        .environmentObject(vm)
    }
}

extension ClubsView {
    var iPadNavButtons: some View {
        HStack {
            Spacer()
            
            // placeholder navbutton
            Spacer()
                .frame(width: 35, height: 35)
                .padding(5)
                .padding(.top, 20)
            
            if selectedPage == .calendar {
                Button {
                    showPicker.toggle()
                } label: {
                    iPadNavButtonView(systemName: "calendar")
                }
                .padding(.trailing, 20)
            }
        }
    }
}
