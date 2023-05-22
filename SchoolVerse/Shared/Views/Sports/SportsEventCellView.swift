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
                    Image(systemName: "mappin")
                    
                    Text(sportsEvent.location)
                    
                    Spacer()
                }
                
                HStack {
                    switch sportsEvent.name.checkSport() {
                    case .soccer:
                        Image(systemName: "soccerball.inverse")
                    case .football:
                        Image(systemName: "football.fill")
                    case .fieldHockey:
                        Image(systemName: "figure.hockey")
                    case .tennis:
                        Image(systemName: "tennis.racket")
                    case .basketball:
                        Image(systemName: "basketball.fill")
                    case .wrestling:
                        Image(systemName: "figure.wrestling")
                    case .squash:
                        Image(systemName: "figure.squash")
                    case .swimming:
                        Image(systemName: "figure.pool.swim")
                    case .fencing:
                        Image(systemName: "figure.fencing")
                    case .baseball:
                        Image(systemName: "figure.baseball")
                    case .softball:
                        Image(systemName: "figure.softball")
                    case .lacrosse:
                        Image(systemName: "figure.lacrosse")
                    case .golf:
                        Image(systemName: "figure.golf")
                    default:
                        Image(systemName: "figure.run")
                    }
                    
                    
                    Text(sportsEvent.name)
                    
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
