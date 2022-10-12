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
    @State var details: UserModel = UserModel(userId: "", displayName: "", gradeLevel: 9, email: "", key: "", schedule: Schedule(days: []), courses: [])
    @State var schoologyCreds: CredentialsDetails =
    CredentialsDetails(username: "", password: "")
    
    @State var validEmail: Bool = false
    @State var validPassword: Bool = false
    @State var validName: Bool = false
    
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(accentColor)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                VStack {
                    Text("Sign Up")
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
                    }
                }
                .padding(.vertical)
                
                VStack {
                    VStack(spacing: 10) {
                        CustomTextField(placeholder: "Enter name", text: $details.displayName)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .warningAccessory($details.displayName, valid: $validName, warning: "Enter a name") { name in
                                isNotEmpty(text: name)
                            }
                        
                        Picker("Grade level", selection: $details.gradeLevel) {
                            ForEach(9..<13) { grade in
                                Text("Grade \(grade)")
                                    .foregroundColor(.white)
                                    .tag(grade)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                .padding(.vertical)
                
                VStack {
                    
                    Button {
                        Task {
                            await vm.signUp(creds: appCreds, details: details)
                        }
                    } label: {
                        Text("Join SchoolVerse!")
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor((validEmail && validPassword && validName) ? Color.white: Color.gray)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .glassCardFull()
                    .padding(.horizontal, 45)
                    .disabled(!(validEmail && validPassword && validName))
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
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

extension SignUpView {
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
