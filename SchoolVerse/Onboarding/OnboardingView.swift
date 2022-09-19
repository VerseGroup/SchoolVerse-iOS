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
        TabView {
            welcomePage
            tutorialPage
            proceedPage
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnboarding: .constant(true))
    }
}

extension OnboardingView {
    
    private var welcomePage: some View {
        VStack {
            Text("Welcome to SchoolVerse!")
        }
    }
    
    private var tutorialPage: some View {
        VStack {
            // insert onboarding stuff
            Text("Lorem Ipsum")
        }
    }
    
    private var proceedPage: some View {
        VStack {
            Button {
                withAnimation(.easeInOut) {
                    showOnboarding.toggle()
                }
            } label: {
                Text("Let's get started!")
            }

        }
    }
}
