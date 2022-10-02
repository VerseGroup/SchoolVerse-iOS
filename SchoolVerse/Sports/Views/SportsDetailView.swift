//
//  SportsDetailView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct SportsDetailView: View {
    let sports: SportsEvent
    
    var body: some View {
        VStack {
            Text(sports.description)
            HStack {
                Text(sports.start.weekDateTimeString())
                Spacer()
                Text(sports.end.weekDateTimeString())
            }
            if let location = sports.location {
                Text(location)
            }
        }
    }
}
