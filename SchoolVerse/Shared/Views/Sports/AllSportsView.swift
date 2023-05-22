//
//  AllSportsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 12/2/22.
//

import SwiftUI

struct AllSportsView: View {
    @EnvironmentObject var vm: SportsListViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            
            Text("All Sports")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            ScrollView(showsIndicators: false) {
                ForEach(vm.selectedAllSportsEvents) { sportEvent in
                    SportsEventCellView(sportsEvent: sportEvent)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                }
                
                // if iphone
                if !(UIDevice.current.userInterfaceIdiom == .pad){
                    Spacer()
                        .frame(height: 95)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .heavyGlass()
    }
}
