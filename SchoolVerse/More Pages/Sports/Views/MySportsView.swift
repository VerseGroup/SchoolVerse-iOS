//
//  MySportsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 12/2/22.
//

import SwiftUI

struct MySportsView: View {
    @EnvironmentObject var vm: SportsListViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            
            Text("My Sports")
                .font(.system(size: 20))
                .fontWeight(.bold)
            
            ScrollView(showsIndicators: false) {
                Text("Coming Soon...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
            
        }
        .frame(maxWidth: .infinity)
        .heavyGlass()
    }
    
}
