//
//  ClubTile.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/9/23.
//

import SwiftUI

struct ClubTile: View {
    var name: String
    var leaders: [String]
    var meetingBlocks: [String]
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            Text(leaders.joined(separator: ", "))
                .font(.headline)
            
            Text(meetingBlocks.joined(separator: "; "))
        }
        .foregroundColor(Color.white)
        .padding()
        .padding(.leading, 10)
        .glassCardFull()
        .padding()
    }
}
