//
//  ScheduleRepository.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/9/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

// TODO: add cache for schedule on UserDefaults
// TODO: add automatic cache for day events from firebase (doesn't really matter, but make sure to change for next school year)
class ScheduleRepository: ObservableObject {
    private let dayPath: String = "days"
    private let schedulePath: String = "schedule"
    private let docRef: DocumentReference
    private let userId: String
    private let db = Firestore.firestore()
    
    @Published var dayEvents: [DayEvent] = [] // which days are day 1,2,3,4,5,6,7,...
    @Published var schedule: Schedule? // user's schedule
    
    @Published var errorMessage: String?
    
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
            userId = "bruh"

            docRef = db.collection("users").document(userId).collection(schedulePath).document(userId)

            return
        }
        
        userId = uid
        
        docRef = db.collection("users").document(userId).collection(schedulePath).document(userId)
        
        print("RUN")
        loadSchedule()
        loadDays()
    }
    
    func loadSchedule() {
        docRef.getDocument(as: Schedule.self) { result in
            switch result {
            case .success(let schedule):
                self.errorMessage = nil
                self.schedule = schedule
            case .failure(let error):
                switch error {
                case DecodingError.typeMismatch(_, let context):
                    self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                case DecodingError.valueNotFound(_, let context):
                    self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                case DecodingError.keyNotFound(_, let context):
                    self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                case DecodingError.dataCorrupted(let key):
                    self.errorMessage = "\(error.localizedDescription): \(key)"
                default:
                    self.errorMessage = "Error decoding document: \(error.localizedDescription)"
                }
                self.schedule = nil
            }
        }
    }
    
    func loadDays() {
        // reading dayevents from on device json
        guard let url = Bundle.main.url(forResource: "days", withExtension: "json") else {
            print("Json file not found")
            return
        }
        
        let data = try? Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        print("Decoding from JSON :)")
        let days = try? decoder.decode([DayEvent].self, from: data!)
        self.dayEvents = days ?? []
        
        // reading dayevents from firebase db
//        db.collection(dayPath)
//            .addSnapshotListener { [weak self] (querySnapshot, error) in
//                guard let documents = querySnapshot?.documents else {
//                    self?.errorMessage = "No days found"
//                    return
//                }
//                self?.dayEvents = documents.compactMap({ queryDocumentSnapshot in
//                    let result = Result { try queryDocumentSnapshot.data(as: DayEvent.self) }
//
//                    switch result {
//                    case .success(let day):
//                        self?.errorMessage = nil
//                        return day
//                    case .failure(let error):
//                        switch error {
//                        case DecodingError.typeMismatch(_, let context):
//                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
//                        case DecodingError.valueNotFound(_, let context):
//                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
//                        case DecodingError.keyNotFound(_, let context):
//                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
//                        case DecodingError.dataCorrupted(let key):
//                            self?.errorMessage = "\(error.localizedDescription): \(key)"
//                        default:
//                            self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
//                        }
//                        return nil
//                    }
//                })
//            }
    }
}
