//
//  ClubAnnouncementsTile.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/10/23.
//

import SwiftUI

struct ClubAnnouncementsTile: View {
    var postedBy: String
    var announcement: String
    var time: Date
    
    var body: some View {
        VStack {
            HStack {
                Text("From \(postedBy): ")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            Text(announcement)
                .font(.callout)
                .fontWeight(.medium)
                .padding(4)
            
            HStack {
                Spacer()
                
                Text(time.formatted())
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
        .foregroundColor(Color.white)
        .padding()
        .glassCardFull()
    }
}
