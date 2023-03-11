//
//  LinkingView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import SwiftUI

struct LinkingView: View {
    @ObservedObject var vm: LinkingViewModel = LinkingViewModel()
    
    @State var accountCreds = CredentialsDetails(username: "", password: "")
    
    @State var validUsername: Bool = false
    @State var validPassword: Bool = false
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView {
                VStack(spacing: 10) {
                    Text("Link School Accounts to SchoolVerse")
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .bold()
                        .padding(.vertical, 20)
                    
                    
                    DisclosureGroup {
                        
                        ParagraphLabel(name:
        """
        \tHackley School has authorized SchoolVerse and VerseGroup to use your data for the sole purpose of providing you this software. Your sensitive data (linked accounts) is end-to-end encrypted, split across both your device and our servers so that physical access to both your phone and our servers is required to view your confidential data. The VerseGroup team cannot see this data. View our privacy policy for extended information on our website.
        """
                        )
                    } label: {
                        HeaderLabel(name: "Linking Notice")
                            .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        HeaderLabel(name: "Enter your Hackley School credentials")
                        
                        CustomTextField(placeholder: "Enter username", text: $accountCreds.username)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .warningAccessory($accountCreds.username, valid: $validUsername, warning: "Username must not be empty") { username in
                                isNotEmpty(text: username)
                            }
                        
                        CustomSecureField(placeholder: "Enter password", text: $accountCreds.password)
                            .warningAccessory($accountCreds.password, valid: $validPassword, warning: "Password must not be empty") { password in
                                isNotEmpty(text: password)
                            }
                        
                        
                        Button {
                            vm.linkAccount(creds: accountCreds)
                        } label: {
                            Text("Link School Accounts")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor((validUsername && validPassword) ? Color.white: Color.gray)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .glassCardFull()
                        .padding(.horizontal, 45)
                        .padding(.vertical, 20)
                        .disabled(!(validUsername && validPassword))
                        
                        Button {
                            Task {
                                await vm.signOut()
                            }
                        } label: {
                            Text("Sign Out")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .glassCardFull()
                        .padding(.horizontal, 45)
                        .padding(.vertical, 20)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .overlay {
            if vm.isLoading {
                LoadingView(text: "Verifying account...")
            }
        }
        .alert("Error", isPresented: $vm.hasError, actions: {
            Button("OK", role: .cancel) { }
        }) {
            Text(vm.errorMessage ?? "")
        }
        .preferredColorScheme(.dark)
    }
}

struct LinkingView_Previews: PreviewProvider {
    static var previews: some View {
        LinkingView()
    }
}
