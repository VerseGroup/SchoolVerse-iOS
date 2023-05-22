//
//  EventCellView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct EventCellView: View {
    let event: Event
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            if event.summary.contains(" - ") {
                Text(event.summary.split(separator: " - ", maxSplits: 1)[1])
                    .font(.system(size: 25))
            } else {
                Text(event.summary)
                    .font(.system(size: 25))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "clock")
                    
                    VStack (alignment: .leading, spacing: 10){
                        Text(event.day.weekDateString())
                        
                        if let start = event.start, let end = event.end {
                            Text("\(start.timeString()) - \(end.timeString())")
                        }
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "mappin")
                    
                    Text(event.location)
                    
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
