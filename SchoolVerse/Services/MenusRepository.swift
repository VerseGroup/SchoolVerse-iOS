//
//  MenusRepository.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class MenusRepository: ObservableObject {
    private let path: String = "menus"
    private let db = Firestore.firestore()

    @Published var menus: [SchoolMenu] = []
    @Published var errorMessage: String?
    
    init() {
        loadMenus(date: Date.now)
    }
    
    func loadMenus(date: Date) {
        db.collection(path)
            .whereField("date", isDateInToday: date)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No menus yet"
                    return
                }
                documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: SchoolMenu.self) }
                    
                    switch result {
                    case .success(let menu):
                        self?.errorMessage = nil
                        print(menu.date.description + "DAETE!")
                        
                        if !(self?.menus ?? []).contains(where: {$0.id == menu.id}) {
                            self?.menus.append(menu)
                        }
                        self?.menus.append(menu)
                        return menu
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
