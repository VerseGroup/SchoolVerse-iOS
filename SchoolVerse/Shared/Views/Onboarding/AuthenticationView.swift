//
//  AuthenticationView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/19/22.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var showSignUp: Bool = false
    @State private var showSignIn: Bool = false
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                Image("SV-ClearBG")
                    .frame(width: 300, height: 300)
                    .glassCard()
                    .padding(30)
                
                Text("Welcome to SchoolVerse")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color.white)
                    .font(.system(size: 50, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Button {
                    showSignUp.toggle()
                } label: {
                    Text("Sign Up")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .padding(.vertical, 20)
                .padding(.horizontal, 60)
                .glassCardFull()
                .padding()
                
                Button {
                    showSignIn.toggle()
                } label: {
                    Text("Sign In")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .padding(.vertical, 20)
                .padding(.horizontal, 60)
                .glassCardFull()
                .padding()
                
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .sheet(isPresented: $showSignIn) {
            SignInView()
        }
        .preferredColorScheme(.dark)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
