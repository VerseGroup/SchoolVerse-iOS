//
//  SignInView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/19/22.
//

import SwiftUI
import Resolver

struct SignInView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager
    @State var creds: AppCredentialsDetails = AppCredentialsDetails(email: "", password: "")
    
    @State var validEmail: Bool = false
    @State var validPassword: Bool = false
    
    var body: some View {
        NavigationView {
            Form ( content: {
                TextField("Enter email", text: $creds.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .warningAccessory($creds.email, valid: $validEmail,  warning: "Invalid email") { email in
                        isValidEmail(text: email)
                    }
                SecureField("Enter password", text: $creds.password)
                    .warningAccessory($creds.password, valid: $validPassword, warning: "Password must be 6 or more characters") { password in
                        isValidLength(text: password)
                    }
                
                Button {
                    Task {
                        await authManager.signIn(creds: creds)
                    }
                } label: {
                    Text("Sign in")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .disabled(!(validEmail && validPassword))
            })
            .navigationTitle("Sign In")
            .alert("Error", isPresented: $authManager.hasError, actions: {
                Button("OK", role: .cancel) { }

            }) {
                Text(authManager.errorMessage ?? "")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
