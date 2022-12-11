//
//  PeriodTileAndHeader.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/27/22.
//

import SwiftUI

struct PeriodTileAndHeader: View {
    var periodInfo: PeriodInfo
    var dashBoardTitle: String?
    
    var body: some View {
        VStack {
            HeaderLabel(name: dashBoardTitle ?? periodInfo.period.description)
                .padding(.top, 5)
            
            // Period Tile
            VStack (alignment: .leading) {
                Text("\(periodInfo.startTime) - \(periodInfo.endTime)")
                    .font(.caption)
                
                if periodInfo.course.name.contains(": ") {
                    Text(periodInfo.course.name.split(separator: ": ", maxSplits: 1)[1])
                        .font(.headline)
                } else if periodInfo.course.name == "Free" || periodInfo.course.name == "Lunch"  {
                    Text(periodInfo.course.name)
                        .font(.title)
                        .bold()
                } else {
                    Text(periodInfo.course.name)
                        .font(.headline)
                }
                
                HStack {
                    if periodInfo.course.teacher != "N/A" {
                        Text(periodInfo.course.teacher)
                    }
                    
                    Spacer()
                    
//                    Text(periodInfo.course.room ?? "")
//                        .font(.title2)
//                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(Color.white)
            .padding()
            .padding(.leading, 10)
            .borderedtaintedGlass()
        }
        .padding(.horizontal)
    }
}
