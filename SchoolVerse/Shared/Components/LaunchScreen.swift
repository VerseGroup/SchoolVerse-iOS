//
//  LaunchScreen.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/22/23.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color("BG1")
            
            Image("SV Logo")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
