//
//  OnboardingView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/18/22.
//

import SwiftUI
import Resolver

// TODO: Add detail to onboarding view

struct OnboardingView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager
    
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                Image("VG-ClearBG")
                    .frame(width: 300, height: 300)
                    .glassCard()
                    .padding(30)
                
                Text("Welcome to SchoolVerse")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color.white)
                    .font(.system(size: 50, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Spacer()
                    .frame(height: 75)
                
                Button {
                    withAnimation(.easeInOut) {
                        showOnboarding.toggle()
                    }
                } label: {
                    Text("Let's get started!")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .padding(.vertical, 20)
                .padding(.horizontal, 60)
                .glassCardFull()
                
                Spacer()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnboarding: .constant(true))
    }
}
