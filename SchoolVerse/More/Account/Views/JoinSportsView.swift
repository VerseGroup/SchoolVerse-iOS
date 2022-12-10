//
//  JoinSportsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 11/30/22.
//

import Foundation
import SwiftUI

enum MySports: String, CaseIterable, Hashable {
    case joined = "My Sports"
    case all = "All Sports"
}

struct JoinSportsView: View {
    @StateObject var vm: SportsListViewModel = SportsListViewModel()
    @State var selectedView: MySports = .joined
    
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    HStack (spacing: 20) {
                        ForEach (MySports.allCases, id: \.self) { selection in
                            Text(selection.rawValue)
                                .fontWeight(.semibold)
                                .font(.headline)
                                .frame(width: UIScreen.main.bounds.width / 4)
                                .background (
                                    ZStack {
                                        if selection == selectedView {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(.clear)
                                                .padding(20)
                                                .taintedGlass()
                                                .matchedGeometryEffect(id: "currentView", in: animation)
                                        } //: if
                                    } //: Zstack
                                ) //: background
                                .onTapGesture {
                                    withAnimation {
                                        selectedView = selection
                                    }
                                }
                        } //: ForEach
                    } //: HStack
                    .padding(.vertical, 15)
                    .padding(.horizontal, 5)
                    .cornerRadius(20)
                    .heavyGlass()
                    .padding(.bottom)
                    
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        
                        ScrollView(showsIndicators: false) {
                            switch selectedView{
                            case .joined:
                                joinedList
                            case .all:
                                allList
                            }
                            
                            Spacer()
                                .frame(height: 115)
                        }
                    }
                    .ignoresSafeArea()
                    .heavyGlass()
                    .frame(maxWidth: .infinity)
                    
                }
        }
        .preferredColorScheme(.dark)
        .navigationTitle("Joined Sports")
    }
}

extension JoinSportsView {
    var joinedList: some View {
        Group {
            SubscribedSportsTile(joined: true, sport: Sport(id: "baseball", name: "Baseball - Varsity", link: "testtest", events: []))
            SubscribedSportsTile(joined: true, sport: Sport(id: "basketball", name: "Basketball - Varsity Boys", link: "testtest2", events: []))
            
            Spacer()
        }
    }
    
    var allList: some View {
        ForEach(vm.allSports, content: { sport in
            if !sport.name.contains("Middle School") {
                SubscribedSportsTile(joined: false, sport: sport)
            }
        })
        
    }
}
