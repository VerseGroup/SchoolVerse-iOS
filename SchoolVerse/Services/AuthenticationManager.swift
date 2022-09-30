//
//  AuthenticationManager.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/1/22.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore

// TODO: Fix AuthenticationManagerProtocol to support Dependency Injection
// Type erase AuthenticationManagerProtocol to an AnyAuthenticationManager Class and inject that

protocol AuthenticationManagerProtocol: ObservableObject {
    var userModel: UserModel? { get set }
    var isAuthenticated: Bool { get set }
    
    var errorMessage: String? { get set }
    var hasError: Bool { get set }
    
    func signIn(creds: AppCredentialsDetails) async
    func signOut() async
    func signUp(creds: AppCredentialsDetails, userDetails: UserModel) async
}

// doesn't work because published properties don't update
//
//class AnyAuthenticationManager: AuthenticationManagerProtocol {
//    @Published var showOnboarding: Bool
//
//    @Published var userModel: UserModel?
//    @Published var isAuthenticated: Bool
//    @Published var errorMessage: String?
//
//    private let finishOnboardingWrapper: () -> ()
//    private let signInWrapper: (CredentialsDetails) async -> ()
//    private let signOutWrapper: (CredentialsDetails) async -> ()
//    private let signUpWrapper: (CredentialsDetails, UserModel) async -> ()
//
//    func finishOnboarding() {
//        finishOnboardingWrapper()
//    }
//
//    func signIn(creds: CredentialsDetails) async {
//        await signInWrapper(creds)
//    }
//
//    func signOut(creds: CredentialsDetails) async {
//        await signOutWrapper(creds)
//    }
//
//    func signUp(creds: CredentialsDetails, userDetails: UserModel) async {
//        await signUpWrapper(creds, userDetails)
//    }
//
//    init<T: AuthenticationManagerProtocol>(wrapping manager: T) {
////        self.objectWillChange = manager
////            .objectWillChange
////            .map { _ in () }
////            .eraseToAnyPublisher()
//        self.showOnboarding = manager.showOnboarding
//        self.userModel = manager.userModel
//        self.isAuthenticated = manager.isAuthenticated
//        self.errorMessage = manager.errorMessage
//
//        self.finishOnboardingWrapper = manager.finishOnboarding
//        self.signInWrapper = manager.signIn
//        self.signOutWrapper = manager.signOut
//        self.signUpWrapper = manager.signUp
//    }
//}

class FirebaseAuthenticationManager: AuthenticationManagerProtocol {
    @Published var userModel: UserModel?
    @Published var isAuthenticated: Bool = UserDefaults.standard.bool(forKey: "authenticated")
    
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    private let path: String = "users"
    private let db = Firestore.firestore()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("Authentication Manager initialized")
        addSubscribers()
        registerStateListener()
    }
    
    deinit {
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    private func addSubscribers() {
        
        // waits 5 seconds after errorMessage is changed to erase the errorMessage
        $errorMessage
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.errorMessage = nil
                self.hasError = false
            }
            .store(in: &cancellables)
        
    }
    
    // source: https://peterfriese.dev/posts/replicating-reminder-swiftui-firebase-part2/
    // listens for user session (checks if user is signed in, signed out, user account is available, etc.)
    // handles all the session activities automatically, other functions should not handle isAuthenticated and user
    // source: https://firebase.google.com/docs/auth/ios/start
    private func registerStateListener() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.db.collection(self.path)
                    .document(user.uid)
                    .getDocument(as: UserModel.self) { result in
                        switch result {
                        case .success(let userModel):
                            self.userModel = userModel
                            withAnimation(.easeInOut) {
                                self.isAuthenticated = true
                                UserDefaults.standard.set(true, forKey: "authenticated")
                            }
                        case .failure(let error):
                            self.userModel = nil
                            withAnimation(.easeInOut) {
                                self.isAuthenticated = false
                                UserDefaults.standard.set(false, forKey: "authenticated")
                            }
                            self.errorMessage = "Couldn't get user document from Firestore: \(error.localizedDescription)"
                            self.hasError = true
                        }
                    }
            } else {
                self.userModel = nil
                withAnimation(.easeInOut) {
                    self.isAuthenticated = false
                    UserDefaults.standard.set(false, forKey: "authenticated")
                }
                print("User N/A")
            }
        }
    }
    
    @MainActor
    func signIn(creds: AppCredentialsDetails) async {
        do {
            try await Auth.auth().signIn(withEmail: creds.email, password: creds.password)
            
            // show linking page every time a user signs in
            UserDefaults.standard.set(true, forKey: "show_linking")
        }
        catch {
            print("There was an issue when trying to sign in: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.hasError = true
            }
        }
    }
    
    @MainActor
    func signOut() async {
        do {
            try Auth.auth().signOut()
            
            // clear user defaults 
            UserDefaults.standard.removeObject(forKey: "e_username")
            UserDefaults.standard.removeObject(forKey: "e_password")
            UserDefaults.standard.removeObject(forKey: "public_key")
            UserDefaults.standard.removeObject(forKey: "show_linking")
            UserDefaults.standard.removeObject(forKey: "authenticated")

        } catch {
            print("There was an issue when trying to sign out: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.hasError = true
            }
        }
    }
    
    @MainActor
    func signUp(creds: AppCredentialsDetails, userDetails: UserModel) async {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: creds.email, password: creds.password)
            
            var finalUserDetails = userDetails
            finalUserDetails.email = creds.email
            finalUserDetails.userId = authDataResult.user.uid
            
            try db.collection(path).document(authDataResult.user.uid).setData(from: finalUserDetails)
            
            // show linking page every time a user signs up
            UserDefaults.standard.set(true, forKey: "show_linking")
        } catch {
            print("There was an issue when trying to sign up: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.hasError = true
            }
        }
    }
}

//class DummyAuthenticationManager: ObservableObject, AuthenticationManagerProtocol {
//    var userModel: UserModel?
//
//    var isAuthenticated: Bool
//
//    var errorMessage: String?
//
//    func signIn(creds: CredentialsDetails) {
//        <#code#>
//    }
//
//    func signOut(creds: CredentialsDetails) {
//        <#code#>
//    }
//
//    var userModel: User?
//
//    init() {
//
//    }
//
//
//}
