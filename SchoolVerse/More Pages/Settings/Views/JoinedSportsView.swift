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
                        
                        if !vm.subscribedSports.isEmpty {
                            ScrollView(showsIndicators: false) {
                                joinedList
                                
                                Spacer()
                                    .frame(height: 115)
                            }
                        } else {
                            VStack {
                                Spacer()
                                    .frame(height: 20)
                                
                                Text("No Joined Sports Yet!")
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 60))
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
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
            ForEach(vm.subscribedSports) { sport in
                SubscribedSportsTile(vm: SportsCellViewModel(sport: sport))
            }
            
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
                                    SubscribedSportsTile(vm: SportsCellViewModel(sport: sport))
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
