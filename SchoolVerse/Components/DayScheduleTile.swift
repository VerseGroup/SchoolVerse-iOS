//
//  DayScheduleTile.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/27/22.
//

import SwiftUI

struct DayScheduleTile: View {
    var day: DayEvent
    
    var body: some View {
        VStack(alignment: .center) {
            Text(day.day.description)
                .fontWeight(.semibold)
            Text(
                day.date
                    .formatted(date: .complete, time: .omitted)
                    .dropLast(6)
            )
            .fontWeight(.semibold)
        }
        .font(.headline)
        .foregroundColor(Color.white)
        .padding(8)
        .frame(maxWidth: .infinity)
        .glassCardFull()
    }
}
