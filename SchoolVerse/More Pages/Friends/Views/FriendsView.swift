//
//  FriendsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/4/23.
//

import SwiftUI

struct FriendsView: View {
    @StateObject var vm: FriendsViewModel = FriendsViewModel()
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    Text("DS")
                        .fontWeight(.semibold)
                        .font(.system(size: 60))
                        .padding(30)
                        .background(
                            Circle()
                                .foregroundColor(accentColor)
                        )
                        .padding(.horizontal)
                    
                    Text("Daniel Shola-Philips")
                        .fontWeight(.semibold)
                        .font(.largeTitle)
                        .padding(.horizontal)
                    
                    Text("12th Grade")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 60)
                    
                    NavigationLink {
                        MyFriendsView(text: vm.searchText, starred: false)
                    } label: {
                        Text("View Friends")
                            .largeButton()
                            .padding(5)
                    }
                    
                    NavigationLink {
                        PendingFriendsView(text: vm.searchText)
                    } label: {
                        Text("Review Friend Requests")
                            .largeButton()
                            .padding(5)
                    }
                    
                    NavigationLink {
                        NewFriendsView(text: vm.searchText)
                    } label: {
                        Text("Add Friends")
                            .largeButton()
                            .padding(5)
                    }
                    
                    Spacer()
                        .frame(height: 90)
                }
            }
            .navigationTitle("Friends")
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
