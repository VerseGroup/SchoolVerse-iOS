//
//  ClubsDirectoryView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/16/23.
//

import SwiftUI

struct ClubsDirectoryView: View {
    @EnvironmentObject var vm: ClubsViewModel
    
    @Binding var hideView: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HeaderLabel(name: "My Clubs")
                .padding(.horizontal)
            
            if !vm.joinedClubs.isEmpty {
                ForEach(vm.joinedClubs.sorted(by: { one, two in
                    one.name < two.name
                })) { club in
                    ClubTileView(vm: ClubViewModel(club: club))
                        .simultaneousGesture(TapGesture().onEnded{
                            hideView = true // hides view when transitioning to new page
                        })
                }
            } else {
                ParagraphLabel(name: "You have not joined any clubs yet. Click the \"Discover New Clubs\" button to look at more clubs that you may want to join.")
                    .padding(.horizontal)
            }
            
            Spacer()
                .frame(height: 30)
            
            // source: https://stackoverflow.com/questions/57666620/is-it-possible-for-a-navigationlink-to-perform-an-action-in-addition-to-navigati
            NavigationLink(destination: {
                DiscoverClubsView(vm: vm)
            }, label: {
                Text("Discover New Clubs")
                    .largeButton()
                    .padding(5)
            }).simultaneousGesture(TapGesture().onEnded{
                hideView = true // hides view when transitioning to new page
            })
            
            NavigationLink(destination: {
                CreateClubView(vm: vm)
            }, label: {
                Text("Create New Club")
                    .largeButton()
                    .padding(5)
            }).simultaneousGesture(TapGesture().onEnded{
                hideView = true // hides view when transitioning to new page
            })
            
            Spacer()
                .frame(height: 95)

        }
        .environmentObject(vm)
    }
}
