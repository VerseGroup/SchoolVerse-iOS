//
//  SportsRepository.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

// TODO: optimize sports to use less reads with whereField == date
class SportsRepository: ObservableObject {
    private let path: String = "sports"
    private let db = Firestore.firestore()
    
    private let userRef: DocumentReference
    private let userId: String
    
    @Published var sports: [Sport] = [] // all sports
    
    @Published var subscribedSportIds: [String] = []
    @Published var subscribedSports: [Sport] = [] // the user's subscribed sports
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

            userRef = db.collection("users").document(userId)

            return
        }
        
        userId = uid
        userRef = db.collection("users").document(userId)
        
        getSubscribedSportIds()
        loadSports()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getSubscribedSports()
            
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
        
        $subscribedSportIds
            .sink { _ in
                self.getSubscribedSports()
            }
            .store(in: &cancellables)
        
    }
    
    func loadSports() {
        db.collection(path)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No sports yet"
                    return
                }
                self?.sports = documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: Sport.self) }
                    
                    switch result {
                    case .success(let sport):
                        self?.errorMessage = nil
                        return sport
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
    // gets the user's subscribed sport ids for the loadSubscribedSports() method
    func getSubscribedSportIds() {
        db.collection("users").document(userId)
            .addSnapshotListener({ [weak self] (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    self?.errorMessage = "Error retrieving subscribed sports ids"
                    return
                }
                guard let userModel = try? document.data(as: UserModel.self) else {
                    self?.errorMessage = "Error retrieving subscribed sports ids"
                    return
                }

                self?.subscribedSportIds = userModel.subscribedSports
                self?.subscribedSportIds.append("paul :)")
                print("DEBUG - sports id array: \(self?.subscribedSportIds.debugDescription ?? "")")
            })
        
        // doesn't update automatically - need snapshot listener to be responsive
//        db.collection("users").document(userId).getDocument(as: UserModel.self) { [weak self] result in
//            switch result {
//            case .success(let user):
//                self?.subscribedSportIds = user.subscribedSports
//                self?.subscribedSportIds.append("paul :)") // fixes non-empty array firebase firestore query bug for the 'in' operator
//                print("DEBUG - sports id array: \(self?.subscribedSportIds.debugDescription ?? "")")
//            case .failure(let error):
//                print("Couldn't get courses: \(error.localizedDescription)")
//            }
//        }
    }
    
    func getSubscribedSports() {
        let sportIds = subscribedSportIds + ["paul :))"] // prevents sportsIds from array being empty
        db.collection(path)
            .whereField("id", in: sportIds)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No sports yet"
                    return
                }
                self?.subscribedSports = documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: Sport.self) }
                    
                    switch result {
                    case .success(let sport):
                        self?.errorMessage = nil
                        return sport
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
    
    func addSport(_ sportId: String) {
        userRef.updateData([
            "subscribed_sports": FieldValue.arrayUnion([sportId])
        ])
    }
    
    func removeSport(_ sportId: String) {
        userRef.updateData([
            "subscribed_sports": FieldValue.arrayRemove([sportId])
        ])
    }
}
