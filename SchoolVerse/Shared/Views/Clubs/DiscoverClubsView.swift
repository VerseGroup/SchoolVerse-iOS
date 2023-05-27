//
//  DiscoverClubsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/9/23.
//

import SwiftUI

struct DiscoverClubsView: View {
    @ObservedObject var vm: ClubsViewModel
    
    @State var query: String = ""
    
    @State var hideView: Bool = false
    
    var body: some View {
        ZStack {
            // if iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad){
                ColorfulBackgroundView()
            }
            
            // ipad
            if UIDevice.current.userInterfaceIdiom == .pad {
                ClearBackgroundView()
            }
            
            VStack {
                Spacer()
                    .frame(height: 10)
                
                HStack{
                    SearchBarView(searchText: $query)
                }
                .padding(.leading, 10)
                
                Spacer()
                    .frame(height: 15)
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        Spacer()
                            .frame(height: 20)
                        
                        ForEach(vm.allClubs.filter(search)) { club in
                            DiscoverClubTileView(vm: ClubViewModel(club: club))
                                .simultaneousGesture(TapGesture().onEnded{
                                    hideView = true // hides view when transitioning to new page
                                })
                        }
                        
                        // if iphone
                        if !(UIDevice.current.userInterfaceIdiom == .pad){
                            Spacer()
                                .frame(height: 95)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .heavyGlass()
                }
                
                // if ipad
                if (UIDevice.current.userInterfaceIdiom == .pad){
                    Spacer()
                        .frame(height: 16)
                }
            }
        }
        .navigationTitle("Discover New Clubs")
        .isHidden(hideView)
        .onChange(of: hideView, perform: { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                hideView = false
                print(hideView)
            }
        })
    }
}

extension DiscoverClubsView {
    func search(_ club: Club) -> Bool {
        if club.status {
            if !query.isEmpty {
                return club.name.lowercased().contains(query.lowercased())
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
