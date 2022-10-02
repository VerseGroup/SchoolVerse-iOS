//
//  APIService.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import Foundation
import Firebase
import Combine
import Alamofire

class APIService: ObservableObject {
    let baseURL = CustomEnvironment.rootURLString
    @Published var status: Bool = false
    
    @Published var scrapeResponse: ScrapeResponse?
    @Published var keyResponse: KeyResponse?
    @Published var ensureResponse: EnsureResponse?
    
    @Published var hasError: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        ping()
        addSubscribers()
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
    
    func scrape(completion: @escaping (ScrapeResponse?) -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let encryptedUsername = UserDefaults.standard.object(forKey: "e_username") as? String
        let encryptedPassword = UserDefaults.standard.object(forKey: "e_password") as? String
        
        guard let encryptedUsername else {
            print("Username isn't in UserDefaults")
            return
        }
        
        guard let encryptedPassword else {
            print("Password isn't in UserDefaults")
            return
        }
        
        let parameters: [String: String] = [
            "user_id": userId,
            "e_username": encryptedUsername,
            "e_password": encryptedPassword,
        ]
        
        AF.request(baseURL + "/scrape", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: ScrapeResponse.self) { response in
                debugPrint("scrape response: \(response.description)")
                self.scrapeResponse = response.value
                completion(response.value)
            }
    }
    
    // checks if server is up
    func ping() {
        AF.request(baseURL + "/ping")
            .validate()
            .response { response in
                self.status = true
                debugPrint(response)
            }
    }
    
    // gets a public key from api, encrypts username and password with public key, saves public key and encrypted credentials to userDefaults
    func getKey(creds: CredentialsDetails, completion:@escaping  () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "user_id": userId,
        ]
        
        AF.request(baseURL + "/getkey", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: KeyResponse.self) { response in
                debugPrint("response: \(response.description)")
                self.keyResponse = response.value
                let publicKey = response.value?.publicKey
                if let publicKey {
                    UserDefaults.standard.set(publicKey, forKey: "public_key")
                    
                    let keyString = publicKey.fromBase64()
                    
                    guard let keyString else {
                        print("Keystring couldn't be decoded from base64")
                        return
                    }
                    
                    guard let publicKeyString = PublicKey(pemEncoded: keyString) else {
                        print("Public key could not be PEM encoded")
                        return
                    }
                    
                    let encryptedUsername = ClearText(string: creds.username)
                    let encryptedPassword = ClearText(string: creds.password)
                    
                    do {
                        let encryptedUsernameData = try encryptedUsername.encrypted(with: publicKeyString, by: .rsaEncryptionOAEPSHA256).data
                        let encryptedPasswordData = try encryptedPassword.encrypted(with: publicKeyString, by: .rsaEncryptionOAEPSHA256).data
                        
                        UserDefaults.standard.set(encryptedUsernameData.base64EncodedString(), forKey: "e_username")
                        UserDefaults.standard.set(encryptedPasswordData.base64EncodedString(), forKey: "e_password")
                    } catch {
                        print("Could not encrypt and write to UserDefaults")
                    }
                    completion()
                } else {
                    print("No public key")
                }
            }
    }
    
    // ensures schoology creds are valid ( called after getKey() )
    func ensure(completion: @escaping (EnsureResponse?) -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let encryptedUsername = UserDefaults.standard.object(forKey: "e_username") as? String
        let encryptedPassword = UserDefaults.standard.object(forKey: "e_password") as? String
        
        guard let encryptedUsername else {
            print("Username isn't in UserDefaults")
            return
        }
        
        guard let encryptedPassword else {
            print("Password isn't in UserDefaults")
            return
        }
        
        let parameters: [String: String] = [
            "user_id": userId,
            "e_username": encryptedUsername,
            "e_password": encryptedPassword,
        ]
        
        AF.request(baseURL + "/ensure", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: EnsureResponse.self) { response in
                debugPrint("ensure response: \(response.description)")
                self.ensureResponse = response.value
                
                if response.value?.message == .success {
                    print("linking is finished")
                    UserDefaults.standard.set(false, forKey: "show_linking")
                } else {
                    print("Linking failed - service")
                    self.hasError = true
                    self.errorMessage = "Linking failed"
                }
            }
    }
}

