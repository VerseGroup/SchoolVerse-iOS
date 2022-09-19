//
//  SignUpView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/19/22.
//

import SwiftUI
import Resolver

// TODO: ADD FORM VALIDATION (USING POPOVERS)
// TODO: ADD CELEBRATION BALLOONS ON PROCEED PAGE

struct SignUpView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager
    
    @State var creds: AppCredentialsDetails = AppCredentialsDetails(email: "", password: "")
    @State var details: UserModel = UserModel(userId: "", displayName: "", gradeLevel: 9, email: "")
    
    @State var validEmail: Bool = false
    @State var validPassword: Bool = false
    @State var validName: Bool = false
    
    var body: some View {
        NavigationStack {
            Form( content: {
                Section("Credentials") {
                    TextField("Enter email", text: $creds.email)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .warningAccessory($creds.email, valid: $validEmail, warning: "Invalid email") { email in
                            isValidEmail(text: email)
                        }
                    
                    SecureField("Enter password", text: $creds.password)
                        .warningAccessory($creds.password, valid: $validPassword, warning: "Password must be 6 or more characters") { password in
                            isValidLength(text: password)
                        }
                }
                
                Section("Personal Details") {
                    TextField("Enter your name", text: $details.displayName)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .warningAccessory($details.displayName, valid: $validName, warning: "Enter a name") { name in
                        isNotEmpty(text: name)
                    }
                    Picker("Grade level", selection: $details.gradeLevel) {
                        ForEach(9..<13) { grade in
                            Text("Grade \(grade)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Button {
                        Task {
                            await authManager.signUp(creds: creds, userDetails: details)
                        }
                    } label: {
                        Text("Sign Up")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .disabled(!(validEmail && validPassword && validName))
                }
                
            })
            .navigationTitle("Sign Up")
            .alert("Error", isPresented: $authManager.hasError, actions: {
                Button("OK", role: .cancel) { }

            }) {
                Text(authManager.errorMessage ?? "")
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

