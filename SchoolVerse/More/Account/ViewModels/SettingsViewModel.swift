//
//  SettingsViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/9/22.
//

import Foundation
import Combine
import Resolver
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published private var authManager: FirebaseAuthenticationManager = Resolver.resolve()

    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    @Published var userModel: UserModel?
    
    @Published var accentColorLocal: Color = .accent.cyan
    
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        accentColorLocal = accentColor
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        $accentColorLocal
            .sink { (returnedColor) in
                self.accentColor = returnedColor
            }
            .store(in: &cancellables)
        
        authManager.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage
                
                if returnedErrorMessage != nil {
                    self?.hasError = true
                }
            }
            .store(in: &cancellables)
        
        // waits 5 seconds after errorMessage is changed to erase the errorMessage
        $errorMessage
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.errorMessage = nil
                self.hasError = false
            }
            .store(in: &cancellables)
        
        authManager.$userModel
            .sink { [weak self] (returnedUserModel) in
                self?.userModel = returnedUserModel
            }
            .store(in: &cancellables)
        
    }
    
    func signOut() async {
        await authManager.signOut()
    }
    
    func deleteAccount() {
        authManager.deleteUser()
    }
    
    func changeAccentColor(color: Color) {
        accentColorLocal = color
    }
    
    @MainActor
    func sendPasswordReset() {
        authManager.sendPasswordReset()
    }
}
