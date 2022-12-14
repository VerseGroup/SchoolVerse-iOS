//
//  SettingsView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/9/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm: SettingsViewModel = SettingsViewModel()
    
    var colors: [Color] = [Color.accent.blue, Color.accent.cyan, Color.accent.pink, Color.accent.purple]
    var colorNames: [String] = ["Blue", "Cyan", "Pink", "Purple"]
    
    @State var showDelete: Bool = false
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView {
                VStack {
                    if let user = vm.userModel {
                        VStack(spacing: 20) {
                            Spacer()
                                .frame(height: 5)
                            
                            TextWithTitle(placeholder: "Email", text: user.email)
                                .padding(.horizontal)
                            
                            TextWithTitle(placeholder: "Name", text: user.displayName)
                                .padding(.horizontal)
                            
//                            NavigationLink(
//                                destination: JoinedSportsView(),
//                                label: {
//                                    NavigationLinkLabel(name: "My Sports")
//                                        .padding(.horizontal)
//                                    
//                                }
//                            )
                            
                            colorPicker
                                .padding(.horizontal)
                            
                            Spacer()
                                .frame(height: 15)
                            
                            Button {
                                vm.sendPasswordReset()
                            } label: {
                                Text("Send Password Reset")
                            }
                            .largeButton()
                            
                            Button {
                                Task {
                                    await vm.signOut()
                                }
                            } label: {
                                Text("Sign Out")
                            }
                            .largeButton()
                            
                            Button {
                                showDelete.toggle()
                            } label: {
                                Text("Delete Account")
                            }
                            .largeButton()
                            
                            Spacer()
                                .frame(height: 90)
                        }
                    } else {
                        LoadingView(text: "Getting User Data")
                    }
                }
                .padding(.horizontal)
                .alert(isPresented: $showDelete) {
                    Alert(
                        title: Text("Are you sure you want to delete your account?"),
                        primaryButton: .destructive(Text("Delete Account")) {
                            vm.deleteAccount()
                        },
                        secondaryButton: .cancel()
                    )
            }
            }
        }
        .navigationTitle("Settings")
    }
}

extension SettingsView {
    
    var colorPicker: some View {
        VStack(spacing: 0) {
            HStack {
                Text("App Color")
                    .foregroundColor(Color.white)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.bottom, 7)
            
            HStack (spacing: 30) {
                ForEach(0..<colors.count, id: \.self) { index in
                    VStack {
                        Circle()
                            .stroke(vm.accentColorLocal.rawValue == colors[index].rawValue ? .white : .clear, lineWidth: 3.5)
                            .background(
                                Circle().foregroundStyle(colors[index].gradient)
                            )
                            .frame(width: 50)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(colorNames[index].description)
                            .foregroundColor(Color.white)
                            .font(.subheadline)
                            .fontWeight(vm.accentColorLocal.rawValue == colors[index].rawValue ? .bold : .light)
                    }
                    .onTapGesture {
                        withAnimation() {
                            vm.changeAccentColor(color: colors[index])
                        }
                    }
                }
            }
            .padding(25)
            .glass()
        }
    }
}
