//
//  LinkingView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import SwiftUI

struct LinkingView: View {
    @ObservedObject var vm: LinkingViewModel = LinkingViewModel()
    
    @State var schoologyCreds = CredentialsDetails(username: "", password: "")
    
    @State var validUsername: Bool = false
    @State var validPassword: Bool = false
    
    var body: some View {
        VStack {
            TabView {
                veracrossPage
                schoologyPage
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .alert("Error", isPresented: $vm.hasError, actions: {
            Button("OK", role: .cancel) { }
        }) {
            Text(vm.errorMessage ?? "")
        }
    }
}

struct LinkingView_Previews: PreviewProvider {
    static var previews: some View {
        LinkingView()
    }
}

extension LinkingView {
    
    private var schoologyPage: some View {
        VStack {
            Text("Link Schoology to SchoolVerse")
            
            Text("Your credentials are saved on device and whenever your tasks are updated, they are end to end encrypted blah blah blah")
            
            Text("Please enter your Schoology credentials to link Schoology to SchoolVerse")
            
            VStack {
                TextField("Enter username", text: $schoologyCreds.username)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .warningAccessory($schoologyCreds.username, valid: $validUsername, warning: "Username must not be empty") { username in
                        isNotEmpty(text: username)
                    }
                    .padding(10)
                    .background(
                        Color.gray
                    )
                    .cornerRadius(10)
                
                SecureField("Enter password", text: $schoologyCreds.password)
                    .warningAccessory($schoologyCreds.password, valid: $validPassword, warning: "Password must not be empty") { password in
                        isNotEmpty(text: password)
                    }
                    .padding(10)
                    .background(
                        Color.gray
                    )
                    .cornerRadius(10)
                
                Button {
                    vm.linkSchoology(creds: schoologyCreds)
                } label: {
                    Text("Link Schoology creds")
                }
                .disabled(!(validUsername && validPassword))

            }
        }
        .overlay {
            if vm.isLoading {
                ProgressView("Verifying Schoology credentials...")
            }
        }
    }
    
    private var veracrossPage: some View {
        VStack {
            Text("Link veracross")
        }
    }
}
