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
            fatalError("userId invalid")
        }
        userId = uid
        
        docRef = db.collection("users").document(userId).collection(schedulePath).document(userId)
        
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
        db.collection(dayPath)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No days found"
                    return
                }
                self?.dayEvents = documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: DayEvent.self) }
                    
                    switch result {
                    case .success(let day):
                        self?.errorMessage = nil
                        return day
                    case .failure(let error):
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
}
