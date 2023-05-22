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
    
    @State var showForgotPasswordView: Bool = false
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                VStack {
                    Text("Sign In")
                        .font(.title)
                        .bold()
                        .padding(.vertical, 20)
                    Spacer()
                    
                    VStack(spacing: 10) {
                        
                        CustomTextField(placeholder: "Enter email", text: $appCreds.email)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .warningAccessory($appCreds.email, valid: $validEmail, warning: "Invalid email") { email in
                                isValidEmail(text: email)
                            }
                        
                        CustomSecureField(placeholder: "Enter password", text: $appCreds.password)
                            .warningAccessory($appCreds.password, valid: $validPassword, warning: "Password must be 6 or more characters") { password in
                                isValidLength(text: password)
                            }
                        
                        HStack() {
                            Spacer()
                            
                            Button {
                                showForgotPasswordView.toggle()
                            } label: {
                                Text("Forgot password?")
                                    .foregroundColor(Color.accent.cyan)
                                    .padding(5)
                            }
                            
                        }
                        
                    }
                }
                .padding(.vertical)
                
                VStack {
                    
                    Button {
                        Task {
                            await vm.signIn(creds: appCreds)
                        }
                    } label: {
                        Text("Sign In")
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor((validEmail && validPassword) ? Color.white: Color.gray)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .glassCardFull()
                    .padding(.horizontal, 45)
                    .disabled(!(validEmail && validPassword))
                }
                .padding(.vertical)
                
                Spacer()
                    .frame(height: 95)
            }
            .padding()
        }
        .alert("Error", isPresented: $vm.hasError, actions: {
            Button("OK", role: .cancel) { }
        }) {
            Text(vm.errorMessage ?? "")
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showForgotPasswordView) {
            ForgotPasswordView(vm: vm)
        }
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
