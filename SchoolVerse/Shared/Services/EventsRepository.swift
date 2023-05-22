//
//  EventsRepository.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class EventRepository: ObservableObject {
    private let path: String = "events"
    private let db = Firestore.firestore()
    
    @Published var events: [Event] = []
    @Published var errorMessage: String?

    init() {
        loadEvents(date: Date())
    }
    
    func loadEvents(date: Date) {
        db.collection(path)
            .whereField("day", isDateInToday: date)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No events yet"
                    return
                }
                documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: Event.self) }
                    
                    switch result {
                    case .success(let event):
                        self?.errorMessage = nil
                        if !(self?.events ?? []).contains(where: {$0.id == event.id}) {
                            self?.events.append(event)
                        }
                        return event
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
