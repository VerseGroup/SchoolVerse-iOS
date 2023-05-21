//
//  ClubEventTile.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/17/23.
//

import SwiftUI

struct ClubEventTile: View {
    @EnvironmentObject var vm: ClubViewModel
    
    let clubEvent: ClubEvent
    
    @State var showClubEventDetailView: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(clubEvent.title)
                .font(.system(size: 25))
            
            Spacer()
                .frame(height: 5)
            
            if !clubEvent.description.isEmpty {
                DisclosureGroup {
                    HStack {
                        Text(clubEvent.description)
                            .padding(.horizontal, 7)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                } label: {
                    HeaderLabel(name: "Description")
                }
            }
            
            
            Spacer()
                .frame(height: 10)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "clock")
                    
                    VStack (alignment: .leading, spacing: 10){
                        Text(clubEvent.start.weekDateString())
                        
                        Text("\(clubEvent.start.timeString()) - \(clubEvent.end.timeString())")
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "mappin")
                    
                    Text(clubEvent.location)
                    
                    Spacer()
                }
            }
        }
        .padding()
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .glassCardFull()
        .environmentObject(vm)
        .onTapGesture {
            if vm.isLeader {
                showClubEventDetailView.toggle()
            }
        }
        .sheet(isPresented: $showClubEventDetailView) {
            NavigationStack {
                ClubEventDetailView(clubEvent: clubEvent)
            }
        }
    }
}

struct ClubCalendarEventTile: View {
    let clubEvent: ClubEvent
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            Text(clubEvent.title)
                .font(.system(size: 25))
            
            if !clubEvent.description.isEmpty {
                DisclosureGroup {
                    HStack {
                        Text(clubEvent.description)
                            .padding(.horizontal, 7)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                } label: {
                    HeaderLabel(name: "Description")
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "clock")
                    
                    VStack (alignment: .leading, spacing: 10){
                        Text(clubEvent.start.weekDateString())
                        
                        Text("\(clubEvent.start.timeString()) - \(clubEvent.end.timeString())")
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "mappin")
                    
                    Text(clubEvent.location)
                    
                    Spacer()
                }
            }
        }
        .padding()
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .taintedGlass()
    }
}
