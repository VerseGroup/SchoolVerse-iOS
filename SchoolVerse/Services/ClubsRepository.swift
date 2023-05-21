//
//  ClubsRepository.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/10/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import Resolver

class ClubsRepository: ObservableObject {
    @Published private var api: APIService = Resolver.resolve()

    private let path: String = "clubs"
    private let db = Firestore.firestore()

    let userId: String
    
    private var displayName: String = ""
    
    @Published var clubs: [Club] = [] // all sports
    
    @Published var joinedClubIds: [String] = []
    @Published var joinedClubs: [Club] = [] // the user's joined clubs
        
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        let uid = Auth.auth().currentUser?.uid
        
        guard let uid else {
            do {
                try Auth.auth().signOut()
                
                // clear user defaults
                UserDefaults.standard.removeObject(forKey: "e_username")
                UserDefaults.standard.removeObject(forKey: "e_password")
                UserDefaults.standard.removeObject(forKey: "public_key")
                UserDefaults.standard.removeObject(forKey: "show_linking")
                UserDefaults.standard.set(false, forKey: "authenticated")
                print("Signed out")
            } catch {
                print("There was an issue when trying to sign out: \(error)")
            }
            userId = "bruh" // error, set userId to a fake userId
            
            return
        }
        
        userId = uid
        
        loadClubs()
        getJoinedClubIds()
        getDisplayName()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getJoinedClubs()
            
            self.addSubscribers()
        }
    }
    
    private func addSubscribers() {
        
        // waits 5 seconds after errorMessage is changed to erase the errorMessage
        $errorMessage
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.errorMessage = nil
            }
            .store(in: &cancellables)
        
        $joinedClubIds
            .sink { _ in
                self.getJoinedClubs()
            }
            .store(in: &cancellables)
        
    }
    
    func getDisplayName() {
        db.collection("users").document(userId).getDocument(as: UserModel.self) { [weak self] result in
            switch result {
            case .success(let user):
                self?.displayName = user.displayName
            case .failure(let error):
                print("Couldn't get display name: \(error.localizedDescription)")
            }
        }
    }
    
    func loadClubs() {
        db.collection(path)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No clubs yet"
                    return
                }
                self?.clubs = documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: Club.self) }
                    
                    switch result {
                    case .success(let club):
                        self?.errorMessage = nil
                        return club
                    case .failure(let error):
                        print(error)
                        switch error {
                        case DecodingError.typeMismatch(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.valueNotFound(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.keyNotFound(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.dataCorrupted(let key):
                            self?.errorMessage = "\(error.localizedDescription): \(key)"
                        default:
                            self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
                        }
                        return nil
                    }
                })
            }
    }
    
    // helper function
    // gets the user's joined club ids for the loadJoinedClubs() method
    func getJoinedClubIds() {
        db.collection("users").document(userId)
            .addSnapshotListener({ [weak self] (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    self?.errorMessage = "Error retrieving joined clubs ids"
                    return
                }
                guard let userModel = try? document.data(as: UserModel.self) else {
                    self?.errorMessage = "Error retrieving joined clubs ids"
                    return
                }
                
                self?.joinedClubIds = userModel.joinedClubs
                self?.joinedClubIds.append("paul :)")
                print("DEBUG - joined clubs id array: \(self?.joinedClubIds.debugDescription ?? "")")
            })
    }
    
    func getJoinedClubs() {
        let clubIds = joinedClubIds + ["paul :))"] // prevents clubIds from array being empty
        db.collection(path)
            .whereField("id", in: clubIds)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No joined clubs yet"
                    return
                }
                self?.joinedClubs = documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: Club.self) }
                    
                    switch result {
                    case .success(let club):
                        self?.errorMessage = nil
                        return club
                    case .failure(let error):
                        print(error)
                        switch error {
                        case DecodingError.typeMismatch(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.valueNotFound(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.keyNotFound(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.dataCorrupted(let key):
                            self?.errorMessage = "\(error.localizedDescription): \(key)"
                        default:
                            self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
                        }
                        return nil
                    }
                })
            }
    }
    
    // finish below

    func createClub(_ club: Club) {
        api.createClub(club: club, leaderName: displayName) {
            // code after create club
        }
    }
    
    func deleteClub(_ club: Club) {
        api.deleteClub(club: club) {
            // code after delete club
        }
    }
    
    func joinClub(_ club: Club) {
        api.joinClub(club: club) {
            // code after join club
        }
    }

    func leaveClub(_ club: Club) {
        api.leaveClub(club: club) {
            // code after leave club
        }
    }
    
    func announceClub(club: Club, announcement: String) {
        api.announceClub(club: club, announcement: announcement, leaderName: displayName) {
            // code after announce club
        }
    }
    
    func createClubEvent(clubEvent: ClubEvent) {
        api.createClubEvent(clubEvent: clubEvent) {
            // code after create club event
        }
    }
    
    func updateClubEvent(clubEvent: ClubEvent) {
        api.updateClubEvent(clubEvent: clubEvent) {
            // code after update club event
        }
    }
    
    func deleteClubEvent(clubEvent: ClubEvent) {
        api.deleteClubEvent(clubEvent: clubEvent) {
            // code after delete club event
        }
    }
}
