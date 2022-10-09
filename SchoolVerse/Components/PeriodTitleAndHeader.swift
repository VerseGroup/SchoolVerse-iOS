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
                
                Text(periodInfo.course.name)
                    .font(
                        periodInfo.course.name == "Lunch" ||
                        periodInfo.course.name == "Free Period!"
                        ? .title : .headline)
                    .fontWeight(.semibold)
                
                HStack {
                    Text(periodInfo.course.teacher)
                    
                    Spacer()
                    
//                    Text(periodInfo.course.room ?? "")
//                        .font(.title2)
//                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(Color.white)
            .padding()
            .padding(.leading, 10)
            .glassCardFull()
        }
    }
}
