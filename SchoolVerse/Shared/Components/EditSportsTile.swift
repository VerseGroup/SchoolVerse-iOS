//
//  EditSportsTile.swift
//  SchoolVerse
//
//  Created by dshola-philips on 12/2/22.
//

import SwiftUI

struct MySportsTile : View {
    @ObservedObject var vm: SportsCellViewModel

    var body: some View {
        HStack(spacing: 10) {
            Text(vm.sport.name)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            switch vm.sport.name.checkSport() {
            case .soccer:
                Image(systemName: "soccerball.inverse")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .football:
                Image(systemName: "football.fill")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .fieldHockey:
                Image(systemName: "figure.hockey")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .tennis:
                Image(systemName: "tennis.racket")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .basketball:
                Image(systemName: "basketball.fill")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .wrestling:
                Image(systemName: "figure.wrestling")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .squash:
                Image(systemName: "figure.squash")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .swimming:
                Image(systemName: "figure.pool.swim")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .fencing:
                Image(systemName: "figure.fencing")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .baseball:
                Image(systemName: "figure.baseball")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .softball:
                Image(systemName: "figure.softball")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .lacrosse:
                Image(systemName: "figure.lacrosse")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .golf:
                Image(systemName: "figure.golf")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            default:
                Image(systemName: "figure.run")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            }
                
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .padding()
        .padding(.leading, 10)
        .taintedGlass()
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct EditSportsTile : View {
    @ObservedObject var vm: SportsCellViewModel

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: vm.joined ? "checkmark.circle.fill" : "circle")
                .foregroundColor(Color.white)
                .font(.system(size: 30))
                .padding(.leading, 5)
                .onTapGesture {
                    print("clicked")
                    withAnimation(.easeIn) {
                        self.vm.updateSport()
                    }
                }
            
            Text(vm.sport.name)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            switch vm.sport.name.checkSport() {
            case .soccer:
                Image(systemName: "soccerball.inverse")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .football:
                Image(systemName: "football.fill")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .fieldHockey:
                Image(systemName: "figure.hockey")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .tennis:
                Image(systemName: "tennis.racket")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .basketball:
                Image(systemName: "basketball.fill")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .wrestling:
                Image(systemName: "figure.wrestling")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .squash:
                Image(systemName: "figure.squash")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .swimming:
                Image(systemName: "figure.pool.swim")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .fencing:
                Image(systemName: "figure.fencing")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .baseball:
                Image(systemName: "figure.baseball")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .softball:
                Image(systemName: "figure.softball")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .lacrosse:
                Image(systemName: "figure.lacrosse")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            case .golf:
                Image(systemName: "figure.golf")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            default:
                Image(systemName: "figure.run")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
            }
                
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .padding()
        .padding(.leading, 10)
        .taintedGlass()
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
