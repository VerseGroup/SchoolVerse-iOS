//
//  ClubTileView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/9/23.
//

import SwiftUI

struct ClubTileView: View {
    @ObservedObject var vm: ClubViewModel
    
    @State var showClubPageView: Bool = false
    
    var body: some View {
        // iphone
        if !(UIDevice.current.userInterfaceIdiom == .pad) {
            NavigationLink {
                ClubPageView(vm: vm)
            } label: {
                VStack(alignment: .leading){
                    HStack {
                        Text(vm.club.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    
                    Text(vm.club.leaderNames.joined(separator: ", "))
                        .font(.headline)
                    
                    if !vm.club.status {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 15))
                                                    
                            Text("Club awaiting approval")
                                .font(.system(size: 15))
                            
                            Spacer()
                        }
                        .padding(.vertical, 1)
                    }
                    
                }
                .foregroundColor(Color.white)
                .padding()
                .padding(.leading, 10)
                .glassCardFull()
                .padding()
                .multilineTextAlignment(.leading)
            }
        }
        
        // ipad
        if UIDevice.current.userInterfaceIdiom == .pad {
            Button {
                showClubPageView.toggle()
            } label: {
                VStack(alignment: .leading){
                    HStack {
                        Text(vm.club.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    
                    Text(vm.club.leaderNames.joined(separator: ", "))
                        .font(.headline)
                    
                    if !vm.club.status {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 15))
                                                    
                            Text("Club awaiting approval")
                                .font(.system(size: 15))
                            
                            Spacer()
                        }
                        .padding(.vertical, 1)
                    }
                    
                }
                .foregroundColor(Color.white)
                .padding()
                .padding(.leading, 10)
                .glassCardFull()
                .padding()
                .multilineTextAlignment(.leading)
            }
            .sheet(isPresented: $showClubPageView) {
                NavigationStack {
                    ClubPageView(vm: vm)
                }
            }
        }
    }
}

struct DiscoverClubTileView: View {
    @ObservedObject var vm: ClubViewModel
    
    @State var showClubPageView: Bool = false

    var body: some View {
        // iphone
        if !(UIDevice.current.userInterfaceIdiom == .pad) {
            NavigationLink {
                ClubPageView(vm: vm)
            } label: {
                VStack(alignment: .leading){
                    HStack {
                        Text(vm.club.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    
                    Text(vm.club.leaderNames.joined(separator: ", "))
                        .font(.headline)
                }
                .foregroundColor(Color.white)
                .padding()
                .padding(.leading, 10)
                .taintedGlass()
                .padding(5)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.leading)
            }
        }
        
        // ipad
        if UIDevice.current.userInterfaceIdiom == .pad {
            Button {
                showClubPageView.toggle()
            } label: {
                VStack(alignment: .leading){
                    HStack {
                        Text(vm.club.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    
                    Text(vm.club.leaderNames.joined(separator: ", "))
                        .font(.headline)
                }
                .foregroundColor(Color.white)
                .padding()
                .padding(.leading, 10)
                .taintedGlass()
                .padding(5)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.leading)
            }
            .sheet(isPresented: $showClubPageView) {
                NavigationStack {
                    ClubPageView(vm: vm)
                }
            }
        }
    }
}
