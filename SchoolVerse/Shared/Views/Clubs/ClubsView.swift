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
    
    @State var hideView: Bool = false // hides view to prevent animation bug with clear background view
    
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
                    ClubsDirectoryView(hideView: $hideView)
                case .calendar:
                    ClubsCalendarView()
                }
            }
            .alert("Error", isPresented: $vm.hasError, actions: {
                Button("OK", role: .cancel) { }
            }) {
                Text(vm.errorMessage ?? "")
            }
        }
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
        .isHidden(hideView)
        .onChange(of: hideView, perform: { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                hideView = false
            }
        })
        .environmentObject(vm)
        .environmentObject(vm.weekStore)
    }
}
