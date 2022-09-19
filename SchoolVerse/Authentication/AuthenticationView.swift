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
        VStack {
            Text("Continue with SchoolVerse")
            
            Button {
                showSignUp.toggle()
            } label: {
                Text("Sign Up")
            }
            
            Button {
                showSignIn.toggle()
            } label: {
                Text("Sign In")
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
