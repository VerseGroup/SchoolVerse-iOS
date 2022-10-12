//
//  SportsEventCellView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct SportsEventCellView: View {
    let sportsEvent: SportsEvent
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            Text(sportsEvent.summary)
                .font(.system(size: 25))
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "clock")
                    
                    VStack (alignment: .leading, spacing: 10){
                        Text(sportsEvent.start.weekDateString())
                        
                        if let end = sportsEvent.end {
                            Text("\(sportsEvent.start.timeString()) - \(end.timeString())")
                        } else {
                            Text("\(sportsEvent.start.timeString())")
                        }
                    }
                    
                    Spacer()
                }
                
                HStack {
                    if let location = sportsEvent.location {
                        Image(systemName: "mappin")
                        
                        Text(location)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .taintedGlass()
    }
}
