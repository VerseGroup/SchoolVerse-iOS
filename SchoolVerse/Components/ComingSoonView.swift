//
//  ComingSoonView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/10/22.
//

import SwiftUI

struct ComingSoonView: View {
    let title: String
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack (spacing: 25){
                    Image(systemName: "gear")
                        .font(.system(size: 200))
                        .foregroundColor(Color.white)
                    
                    Text("Coming Soon...")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                .padding(30)
                .glassCard()
                
                Spacer()
                Spacer()
            }
            .navigationTitle(title)
            .toolbarColorScheme(.dark, for: .navigationBar)
            //.toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
