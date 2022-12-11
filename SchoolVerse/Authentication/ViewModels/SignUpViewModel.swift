//
//  SignUpViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import Foundation
import Combine
import Resolver
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published private var authManager: FirebaseAuthenticationManager = Resolver.resolve()
    @Published private var api: APIService = Resolver.resolve()
    
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
    
    func signUp(creds: AppCredentialsDetails, details: UserModel) async {
        do {
            authManager.removeStateListener()
            let authDataResult = try await Auth.auth().createUser(withEmail: creds.email, password: creds.password)
            
            var finalUserDetails = details
            finalUserDetails.email = creds.email
            print("CREDS_EMAIL : \(creds.email)")
            finalUserDetails.userId = authDataResult.user.uid
            
            api.createUser(details: finalUserDetails) {
                self.authManager.finishSignUp()
            }
            
        } catch {
            print("There was an issue when trying to sign up: \(error)")
            DispatchQueue.main.async {
                self.authManager.reinstallStateListener()
                self.errorMessage = error.localizedDescription
                self.hasError = true
            }
        }
        
    }
}
