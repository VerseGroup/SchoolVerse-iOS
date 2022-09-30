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
    @State var appCreds: AppCredentialsDetails = AppCredentialsDetails(email: "", password: "")
    
    @ObservedObject var vm: SignInViewModel = SignInViewModel()
    
    @State var validEmail: Bool = false
    @State var validPassword: Bool = false
    
    var body: some View {
        VStack {
            Text("Sign in to SchoolVerse")
                .font(.largeTitle)
                .bold()
            
            VStack {
                TextField("Enter email", text: $appCreds.email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .warningAccessory($appCreds.email, valid: $validEmail, warning: "Invalid email") { email in
                        isValidEmail(text: email)
                    }
                    .padding(10)
                    .background(
                        Color.gray
                    )
                    .cornerRadius(10)
                
                SecureField("Enter password", text: $appCreds.password)
                    .warningAccessory($appCreds.password, valid: $validPassword, warning: "Password must be 6 or more characters") { password in
                        isValidLength(text: password)
                    }
                    .padding(10)
                    .background(
                        Color.gray
                    )
                    .cornerRadius(10)
            }
            
            Button {
                Task {
                    await vm.signIn(creds: appCreds)
                }
            } label: {
                Text("Sign In")
            }
            .disabled(!(validEmail && validPassword))

            
            Spacer()
        }
        .padding()
        .alert("Error", isPresented: $vm.hasError, actions: {
            Button("OK", role: .cancel) { }
        }) {
            Text(vm.errorMessage ?? "")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
