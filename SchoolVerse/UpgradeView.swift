//
//  UpgradeView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/11/22.
//

import SwiftUI

struct UpgradeView: View {
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                Image("SV-ClearBG")
                    .frame(width: 300, height: 300)
                    .glassCard()
                    .padding(30)
                
                Text("A new update has been released, please go to the App Store to continue using.")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .bold()
                    .padding(20)
                    .glassCard()
                    .padding()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct UpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeView()
    }
}
