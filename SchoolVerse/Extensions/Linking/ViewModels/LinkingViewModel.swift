//
//  LinkingViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import Foundation
import Combine
import Resolver

// TODO: add and expose error handling to the linking
class LinkingViewModel: ObservableObject {
    @Published private var authManager: FirebaseAuthenticationManager = Resolver.resolve()
    @Published private var api: APIService = Resolver.resolve()
    
    // firebase
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    // api
    @Published var getDataResponse: GetDataResponse?
    @Published var keyResponse: KeyResponse?
    @Published var ensureResponse: EnsureResponse?
    
    @Published var isLoading: Bool = false
    
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
        
        api.$errorMessage
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
        
        
        api.$getDataResponse
            .sink { [weak self] (returnedGetDataResponse) in
                self?.getDataResponse = returnedGetDataResponse
            }
            .store(in: &cancellables)
        
        // dismisses after 5 seconds
        $getDataResponse
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.getDataResponse = nil
            }
            .store(in: &cancellables)
        
        api.$keyResponse
            .sink { [weak self] (returnedKeyResponse) in
                self?.keyResponse = returnedKeyResponse
            }
            .store(in: &cancellables)
        
        $keyResponse
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.keyResponse = nil
            }
            .store(in: &cancellables)
        
        api.$ensureResponse
            .sink { [weak self] (returnedEnsureResponse) in
                self?.ensureResponse = returnedEnsureResponse
            }
            .store(in: &cancellables)
        
        $ensureResponse
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.ensureResponse = nil
            }
            .store(in: &cancellables)
    }
    
    func getKey(creds: CredentialsDetails, completion: @escaping () -> ()) {
        api.getKey(creds: creds, completion: completion)
    }
    
    func ensure(completion: @escaping (EnsureResponse?) -> ()) {
        api.ensure(completion: completion)
    }
    
    func linkAccount(creds: CredentialsDetails) {
        self.isLoading = true
        getKey(creds: creds, completion: {
            self.ensure(completion: { ensureResponse in
                if ensureResponse?.message == .success {
                    print("Linking success")
                } else {
                    print("Linking failed - vm")
                    self.errorMessage = ensureResponse?.exception
                    self.hasError = true
                }
                self.isLoading = false
            })
            
        })
    }
    
    func signOut() async {
        await authManager.signOut()
    }
}
