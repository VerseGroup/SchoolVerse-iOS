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
            ColorfulBackgroundView()
            
            
            VStack {
                Spacer()
                    .frame(height: 15)
                
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
                
                switch selectedPage {
                case .directory:
                    directory
                case .calendar:
                    calendar
                }
            }
            
            // iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad) {
                GraphicalDatePicker(selectedDate: $vm.selectedDate, isPresented: $showPicker)
            }
        }
        .navigationTitle("Clubs")
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

extension ClubsView {
    var directory: some View {
        ScrollView(showsIndicators: false) {
            HeaderLabel(name: "My Clubs")
                .padding(.horizontal)
            
            ParagraphLabel(name: "You have not started any clubs yet. When you start a club with the club administrator in your school and it gets approved, it will appear here.")
                .padding(.horizontal)
            
            NavigationLink(destination: {
                ClubPageView(isLeader: true, name: "Music Production Club", description: "Teaching Hackley students how to produce industry standard music across any genre", leaders: ["Paul Evans", "Daniel Shola-Philips"], meetingBlocks: ["Day 1 - 12:00", "Day 7 - 12:30"])
                
            }, label: {
                ClubTile(name: "Music Production Club", leaders: ["Paul Evans", "Daniel Shola-Philips"], meetingBlocks: ["Day 1 - 12:00", "Day 7 - 12:30"])
            })
            
            HeaderLabel(name: "Joined Clubs")
                .padding(.horizontal)
            
            ParagraphLabel(name: "You have not joined any clubs yet. Click the \"Discover New Clubs\" button to look at more clubs that you may want to join.")
                .padding(.horizontal)
            
            ClubTile(name: "Hackley CS Club", leaders: ["Paul Evans", "Malcolm Krolick", "Steven Yu"], meetingBlocks: ["Day 1 - 12:00", "Day 7 - 12:00"])
            
            Spacer()
                .frame(height: 30)
            
            NavigationLink(destination: {
                DiscoverClubsView(text: vm.searchText)
            }, label: {
                Text("Discover New Clubs")
                    .largeButton()
                    .padding(5)
            })
            
            Spacer()
                .frame(height: 95)
        }
    }
    
    var calendar: some View {
        Group {
            weekDateSelector
            
            ScrollView(showsIndicators: false) {
                Spacer()
                    .frame(height: 20)
                
                Text("You have no club events today.")
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

extension ClubsView {
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
                        .opacity(day.hasSame(.day, as: Date.now) ? 1 : 0)
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
                        vm.updateSelectedDayEvent(date: day)
                    }
                }
                
                Spacer()
            } //: ForEach
        } //: HStack
    }
    
    var scrollingDateSelector: some View {
        TabView {
            ForEach(0..<3) {_ in
                weekDateSelector
            }
        }
        .frame(height: UIScreen.main.bounds.height / 8)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        
    }
}
