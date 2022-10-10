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
                Text("Continue with SchoolVerse")
                
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
                
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .sheet(isPresented: $showSignIn) {
            SignInView()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
