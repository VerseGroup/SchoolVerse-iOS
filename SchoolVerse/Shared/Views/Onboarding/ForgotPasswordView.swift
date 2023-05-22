//
//  ForgotPasswordView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/22/23.
//

import SwiftUI
import Resolver

struct ForgotPasswordView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager
    
    @ObservedObject var vm: SignInViewModel
    
    @State var email: String = ""
    
    @State var validEmail: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                
                Text("Forgot password?")
                    .font(.title)
                    .bold()
                    .padding(.vertical, 20)
                
                Text("Enter your email and we'll send you a link to reset your password.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                CustomTextField(placeholder: "Enter email", text: $email)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .warningAccessory($email, valid: $validEmail, warning: "Invalid email") { email in
                        isValidEmail(text: email)
                    }
                    .padding(.bottom, 10)
                
                
                Button {
                    Task {
                        await vm.sendPasswordReset(email: email)
                        dismiss()
                    }
                } label: {
                    Text("Send Password Reset")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(validEmail ? Color.white: Color.gray)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .glassCardFull()
                .padding(.horizontal, 45)
                .disabled(!validEmail)
                
                
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
}
