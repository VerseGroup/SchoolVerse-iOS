//
//  AccountView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/9/22.
//

import SwiftUI

struct AccountView: View {
    @StateObject var vm: AccountViewModel = AccountViewModel()
    
    var colors: [Color] = [Color.accent.blue, Color.accent.cyan, Color.accent.pink, Color.accent.purple]
    var colorNames: [String] = ["Blue", "Cyan", "Pink", "Purple"]
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                if let user = vm.userModel {
                    VStack(spacing: 20) {
                        TextWithTitle(placeholder: "Email", text: user.email)
                            .padding(.horizontal)
                        
                        TextWithTitle(placeholder: "Name", text: user.displayName)
                            .padding(.horizontal)
                        
                        colorPicker
                            .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Button {
                            vm.sendPasswordReset()
                        } label: {
                            Text("Send Password Reset")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .glassCardFull()
                        .padding(.horizontal, 45)
                        
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
                        
                        Spacer()
                            .frame(height: 90)
                    }
                } else {
                    Text("User not availale")
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Account")
    }
}

extension AccountView {
    
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
