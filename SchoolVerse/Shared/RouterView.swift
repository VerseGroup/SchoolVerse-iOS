//
//  RouterView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/18/22.
//

import SwiftUI
import Resolver

// TODO: fix transition between app view and linking view
struct RouterView: View {
    @InjectedObject var authManager: FirebaseAuthenticationManager
    @InjectedObject var api: APIService
    
//    @AppStorage("show_onboarding") var showOnboarding: Bool = true
    @AppStorage("show_linking") var showLinking: Bool = false
    
    @State var approveAvailable: Bool = true
    
    @State var showLaunchScreen: Bool = true
    
    var body: some View {
        ZStack {
            // ipad
            if UIDevice.current.userInterfaceIdiom == .pad {
                VStack(spacing: 10) {
                    if api.sameVersion {
                        
                        if authManager.isAuthenticated {
                            VStack(spacing: 10) {
                                if api.approved {
                                    if showLinking {
                                        LinkingView()
                                            .transition(.move(edge: .bottom))
                                    } else {
                                        iPadAppView()
                                            .transition(.move(edge: .bottom))
                                    }
                                } else {
                                    approvalView
                                }
                            }
                            .onAppear {
                                api.approve()
                            }
                        } else {
                            AuthenticationView()
                        }
                        
                    } else {
                        UpgradeView()
                    }
                }
                .onAppear {
                    api.version()
                }
                // iphone
            } else {
                VStack(spacing: 0) {
                    if api.sameVersion {
                        
                        if authManager.isAuthenticated {
                            VStack(spacing: 0) {
                                if api.approved {
                                    if showLinking {
                                        LinkingView()
                                            .transition(.move(edge: .bottom))
                                    } else {
                                        AppView()
                                            .transition(.move(edge: .bottom))
                                    }
                                } else {
                                    approvalView
                                }
                            }
                            .onAppear {
                                api.approve()
                            }
                        } else {
                            AuthenticationView()
                        }
                        
                    } else {
                        UpgradeView()
                    }
                }
                .onAppear {
                    api.version()
                }
            }
            
            if showLaunchScreen {
                LaunchScreen()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showLaunchScreen.toggle()
            }
        }
        
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView()
    }
}

extension RouterView {
    private var approvalView: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                Image("SV-ClearBG")
                    .frame(width: 300, height: 300)
                    .glassCard()
                    .padding(30)
                
                Text("Awaiting Approval\nPlease Check Later")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .bold()
                    .padding(20)
                    .glassCard()
                    .padding()
                
                Button {
                    api.approve()
                    approveAvailable = false
                } label: {
                    Text("Refresh Approval")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(approveAvailable ? Color.white: Color.gray)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .glassCardFull()
                .padding(.horizontal, 45)
                .padding(.vertical, 20)
                .disabled(!approveAvailable)
                
                Button {
                    Task {
                        await authManager.signOut()
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
        }
        .preferredColorScheme(.dark)
    }
}
