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
    @ObservedObject var vm: SignUpViewModel = SignUpViewModel()
    
    @State var appCreds: AppCredentialsDetails = AppCredentialsDetails(email: "", password: "")
    @State var details: UserModel = UserModel(userId: "", displayName: "", gradeLevel: 9, email: "", key: "", schedule: Schedule(days: []))
    @State var schoologyCreds: CredentialsDetails =
    CredentialsDetails(username: "", password: "")
    
    @State var validEmail: Bool = false
    @State var validPassword: Bool = false
    @State var validName: Bool = false
    
    var body: some View {
        TabView {
            credentialsPage
            detailsPage
            buttonPage
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .alert("Error", isPresented: $vm.hasError, actions: {
            Button("OK", role: .cancel) { }
        }) {
            Text(vm.errorMessage ?? "")
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

extension SignUpView {
    private var credentialsPage: some View {
        VStack {
            Text("Set your credentials for SchoolVerse")
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
            
            Spacer()
        }
        .padding()
    }
    
    private var detailsPage: some View {
        VStack {
            TextField("Enter your name", text: $details.displayName)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .warningAccessory($details.displayName, valid: $validName, warning: "Enter a name") { name in
                    isNotEmpty(text: name)
                }
                .padding(10)
                .background(
                    Color.gray
                )
                .cornerRadius(10)
            
            Picker("Grade level", selection: $details.gradeLevel) {
                ForEach(9..<13) { grade in
                    Text("Grade \(grade)")
                        .tag(grade)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
        }
        .padding()
    }
    
    private var buttonPage: some View {
        VStack {
            Text("Sign up!")
            
            Button {
                Task {
                    await vm.signUp(creds: appCreds, details: details)
                }
            } label: {
                Text("Join SchoolVerse!")
            }
            .disabled(!(validEmail && validPassword && validName))
        }
    }
}
