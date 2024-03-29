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
    
    @Published var getDataResponse: GetDataResponse?
    @Published var keyResponse: KeyResponse?
    @Published var ensureResponse: EnsureResponse?
    @Published var versionResponse: VersionResponse?
    @Published var approveResponse: ApproveResponse?
    @Published var createResponse: CreateResponse?
    @Published var deleteResponse: DeleteResponse?
    
    @Published var sameVersion: Bool = true
    
    @Published var hasError: Bool = false
    @Published var errorMessage: String?
    
    @Published var approved: Bool = true
    
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
    
    func getData(completion: @escaping (GetDataResponse?) -> ()) {
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
            "api_key": CustomEnvironment.apiKey
        ]
        
        AF.request(baseURL + "/getdata", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: GetDataResponse.self) { response in
                debugPrint("get data response: \(response.description)")
                self.getDataResponse = response.value
                if response.value?.message == .success {
                    
                } else {
                    self.errorMessage = response.value?.exception
                    self.hasError = true
                }
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
    
    func version() {
        AF.request(baseURL + "/version2")
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: VersionResponse.self) { response in
                debugPrint("response: \(response.description)")
                if let value = response.value {
                    print("Server version: \(value.iosVersion)")
                    print("iOS version: \(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String))")
                    self.versionResponse = value
                    self.sameVersion = value.iosVersion.contains(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")
                }
            }
    }
    
    // gets a public key from api, encrypts username and password with public key, saves public key and encrypted credentials to userDefaults
    func getKey(creds: CredentialsDetails, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "user_id": userId,
            "api_key": CustomEnvironment.apiKey
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
                    print("No public key - too many links")
                    self.hasError = true
                    self.errorMessage = "No public key - too many links"
                }
            }
    }
    
    // ensures creds are valid ( called after getKey() )
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
            "api_key": CustomEnvironment.apiKey
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
    
    func approve() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "user_id": userId,
            "version": (String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)),
            "api_key": CustomEnvironment.apiKey
        ]
        
        AF.request(baseURL + "/approve", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: ApproveResponse.self) { response in
                debugPrint("ensure response: \(response.description)")
                self.approveResponse = response.value
                
                if let value = response.value {
                    if value.message == .success {
                        if response.value?.approved ?? false {
                            self.approved = true
                        } else {
                            self.approved = false
                            self.hasError = true
                            self.errorMessage = "Approve failed"
                        }
                    } else {
                        self.approved = false
                        print("Approve failed")
                        self.hasError = true
                        self.errorMessage = "Approve failed"
                    }
                }
            }
    }
    
    func createUser(details: UserModel, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "user_id": userId,
            "email": details.email,
            "display_name": details.displayName,
            "grade_level": String(details.gradeLevel),
            "api_key": CustomEnvironment.apiKey
        ]
        
        AF.request(baseURL + "/create_user", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: DeleteResponse.self) { response in
                debugPrint("create response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Creating user failed"
                }
            }
    }
    
    func deleteUser(completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "user_id": userId,
            "api_key": CustomEnvironment.apiKey
        ]
        
        AF.request(baseURL + "/delete_user", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: DeleteResponse.self) { response in
                debugPrint("delete response: \(response.description)")
                completion()
            }

    }
    
    
    
    // club functions
    
    func createClub(club: Club, leaderName: String, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: Any] = [
            "name": club.name,
            "description": club.description,
            "leader_ids": [userId],
            "leader_names": [leaderName]
        ]
        
        AF.request(baseURL + "/club/create", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: CreateClubResponse.self) { response in
                debugPrint("create club response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Create club failed: \(response.value?.exception ?? "")"
                }
            }
        
    }
    
    func deleteClub(club: Club, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: Any] = [
            "club_id": club.id,
            "leader_id": userId
        ]
        
        AF.request(baseURL + "/club/delete", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: DeleteClubResponse.self) { response in
                debugPrint("delete response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Deleting club failed: \(response.value?.exception ?? "")"
                }
            }

    }
    
    func joinClub(club: Club, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "member_id": userId,
            "club_id": club.id
        ]
        
        AF.request(baseURL + "/club/join", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: JoinClubResponse.self) { response in
                debugPrint("join response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Joining club failed"
                }
            }
    }
    
    func leaveClub(club: Club, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "member_id": userId,
            "club_id": club.id
        ]
        
        AF.request(baseURL + "/club/leave", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: LeaveClubResponse.self) { response in
                debugPrint("leave response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Leaving club failed"
                }
            }
    }
    
    // finish below
    
    func announceClub(club: Club, announcement: String, leaderName: String, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "club_id": club.id,
            "leader_id": userId,
            "announcement": announcement,
            "leader_name": leaderName
        ]
        
        AF.request(baseURL + "/club/announce", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: AnnounceClubResponse.self) { response in
                debugPrint("announce response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Making club announcement failed"
                }
            }
    }
    
    func createClubEvent(clubEvent: ClubEvent, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "club_id": clubEvent.clubId,
            "start": clubEvent.start.apiDateString(),
            "end": clubEvent.end.apiDateString(),
            "title": clubEvent.title,
            "description": clubEvent.description,
            "location": clubEvent.location,
            "leader_id": userId
        ]
        
        AF.request(baseURL + "/club/event/create", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: CreateClubEventResponse.self) { response in
                debugPrint("create club event response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Create club event failed"
                }
            }
    }
    
    func updateClubEvent(clubEvent: ClubEvent, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "club_id": clubEvent.clubId,
            "id": clubEvent.id,
            "title": clubEvent.title,
            "description": clubEvent.description,
            "start": clubEvent.start.apiDateString(),
            "end": clubEvent.end.apiDateString(),
            "location": clubEvent.location,
            "leader_id": userId
        ]
        
        AF.request(baseURL + "/club/event/update", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: UpdateClubEventResponse.self) { response in
                debugPrint("update club event response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Create club event failed"
                }
            }
    }
    
    func deleteClubEvent(clubEvent: ClubEvent, completion: @escaping () -> ()) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("user not initialized")
            return
        }
        
        let parameters: [String: String] = [
            "club_id": clubEvent.clubId,
            "id": clubEvent.id,
            "leader_id": userId
        ]
        
        AF.request(baseURL + "/club/event/delete", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .cURLDescription { description in
                print(description)
            }
            .response(completionHandler: { data in
                debugPrint(data)
            })
            .responseDecodable(of: DeleteClubEventResponse.self) { response in
                debugPrint("delete club event response: \(response.description)")
                if(response.value?.message == .success) {
                    completion()
                } else {
                    self.hasError = true
                    self.errorMessage = "Create club event failed"
                }
            }
    }
}

