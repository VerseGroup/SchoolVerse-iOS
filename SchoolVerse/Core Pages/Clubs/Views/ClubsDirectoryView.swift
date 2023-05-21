//
//  ClubsDirectoryView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/16/23.
//

import SwiftUI

struct ClubsDirectoryView: View {
    @EnvironmentObject var vm: ClubsViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HeaderLabel(name: "My Clubs")
                .padding(.horizontal)
            
            if !vm.joinedClubs.isEmpty {
                ForEach(vm.joinedClubs.sorted(by: { one, two in
                    one.name < two.name
                })) { club in
                    ClubTileView(vm: ClubViewModel(club: club))
                }
            } else {
                ParagraphLabel(name: "You have not joined any clubs yet. Click the \"Discover New Clubs\" button to look at more clubs that you may want to join.")
                    .padding(.horizontal)
            }
            
            Spacer()
                .frame(height: 30)
            
            NavigationLink(destination: {
                DiscoverClubsView(vm: vm)
            }, label: {
                Text("Discover New Clubs")
                    .largeButton()
                    .padding(5)
            })
            
            NavigationLink(destination: {
                CreateClubView(vm: vm)
            }, label: {
                Text("Create New Club")
                    .largeButton()
                    .padding(5)
            })
            
            Spacer()
                .frame(height: 95)
        }
        .environmentObject(vm) //
    }
}
