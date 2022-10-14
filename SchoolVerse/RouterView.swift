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
    
    var body: some View {
        VStack(spacing: 0) {
            if api.sameVersion {
                if authManager.isAuthenticated {
                    if showLinking {
                        LinkingView()
                            .transition(.move(edge: .bottom))
                    } else {
                        AppView()
                            .transition(.move(edge: .bottom))
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
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView()
    }
}
