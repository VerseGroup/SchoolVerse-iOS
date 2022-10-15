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
    
    @State var confirmPassword: String = ""
    
    @State var validEmail: Bool = false
    @State var validPassword: Bool = false
    @State var validConfirmPassword: Bool = false
    @State var validName: Bool = false
    @State var validAgreement: Bool = false
    
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    @Namespace var animation
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(accentColor)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
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
                        
                        CustomSecureField(placeholder: "Confirm password", text: $confirmPassword)
                            .warningAccessory($confirmPassword, valid: $validConfirmPassword, warning: "Passwords must match") { password in
                                password == appCreds.password
                            }
                    }
                }
                .padding(.vertical)
                
                VStack {
                    VStack(spacing: 20) {
                        CustomTextField(placeholder: "Enter name", text: $details.displayName)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .warningAccessory($details.displayName, valid: $validName, warning: "Enter a name") { name in
                                isNotEmpty(text: name)
                            }
                        
//                        Picker("Grade level", selection: $details.gradeLevel) {
//                            ForEach(9..<13) { grade in
//                                Text("Grade \(grade)")
//                                    .foregroundColor(.white)
//                                    .tag(grade)
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
                        HStack (spacing: 10) {
                            ForEach (9..<13) { grade in
                                Text("Grade \(grade)")
                                    .tag(grade)
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .frame(width: UIScreen.main.bounds.width / 5)
                                    .background (
                                        ZStack {
                                            if grade == details.gradeLevel {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(.clear)
                                                    .padding(20)
                                                    .taintedGlass()
                                                    .matchedGeometryEffect(id: "selectedGrade", in: animation)
                                            } //: if
                                        } //: Zstack
                                    ) //: background
                                    .onTapGesture {
                                        withAnimation {
                                            details.gradeLevel = grade
                                        }
                                    }
                            } //: ForEach
                        } //: HStack
                        .padding(.vertical, 15)
                        .padding(.horizontal, 5)
                        .cornerRadius(20)
                        .heavyGlass()
                        
                        LinkLabel(name: "Privacy/Security Policy", link: URL(string: "https://www.versegroup.tech/privacy")!)
                            .padding(8)
                        
                        HStack {
                            Image(systemName: validAgreement ? "checkmark.square.fill" : "square")
                                .font(.system(size: 25))
                            Text("I agree to the Privacy/Security Policy")
                                .bold(validAgreement)
                        }
                        .padding(15)
                        .glass()
                        .onTapGesture {
                            validAgreement.toggle()
                        }
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
                    .foregroundColor((validEmail && validPassword && validConfirmPassword && validName && validAgreement) ? Color.white: Color.gray)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .glassCardFull()
                    .padding(.horizontal, 45)
                    .disabled(!(validEmail && validPassword && validConfirmPassword && validName && validAgreement))
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
