//
//  JoinedSportsView.swift
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

struct JoinedSportsView: View {
    @StateObject var vm: SportsListViewModel = SportsListViewModel()
    @State var selectedView: MySports = .joined
    @State var showSheet: Bool = false
    
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        
                        ScrollView(showsIndicators: false) {
                            joinedList
                            
                            Spacer()
                                .frame(height: 115)
                        }
                    }
                    .ignoresSafeArea()
                    .heavyGlass()
                    .frame(maxWidth: .infinity)
                    
                }
        }
        .sheet(isPresented: $showSheet) {
            allList
        }
        .preferredColorScheme(.dark)
        .navigationTitle("Joined Sports")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button {
                    showSheet.toggle()
                } label: {
                    NavButtonView(systemName: "plus")
                }
            })
        }
    }
}

extension JoinedSportsView {
    var joinedList: some View {
        Group {
            SubscribedSportsTile(joined: true, sport: Sport(id: "baseball", name: "Baseball - Varsity", link: "testtest", events: []))
            SubscribedSportsTile(joined: true, sport: Sport(id: "basketball", name: "Basketball - Varsity Boys", link: "testtest2", events: []))
            
            Spacer()
        }
    }
    
    var allList: some View {
        NavigationStack {
            ZStack {
                ColorfulBackgroundView()
                
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(vm.allSports, content: { sport in
                                if !sport.name.contains("Middle School") {
                                    SubscribedSportsTile(joined: false, sport: sport)
                                }
                            })
                            
                            Spacer()
                                .frame(height: 115)
                        }
                    }
                    .heavyGlass()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity)
                    
                }
            }
            .navigationTitle("Edit My Sports")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                        showSheet.toggle()
                    } label: {
                        NavButtonView(systemName: "xmark")
                    }
                })
            }
        }
    }
}
