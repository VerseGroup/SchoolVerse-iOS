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
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
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
                        
                        // turn into function
                        ForEach(vm.allClubs.filter(search)) { club in
                            DiscoverClubTileView(vm: ClubViewModel(club: club))
                        }
                        
                        Spacer()
                            .frame(height: 95)
                    }
                    .frame(maxWidth: .infinity)
                    .heavyGlass()
                }
            }
        }
        .navigationTitle("Discover New Clubs")
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
