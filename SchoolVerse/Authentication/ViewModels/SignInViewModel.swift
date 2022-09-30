//
//  SignInViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import Foundation
import Combine
import Resolver

class SignInViewModel: ObservableObject {
    @InjectedObject private var authManager: FirebaseAuthenticationManager
    
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        
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
        
    }
    
    func signIn(creds: AppCredentialsDetails) async {
        await authManager.signIn(creds: creds)
    }
}
