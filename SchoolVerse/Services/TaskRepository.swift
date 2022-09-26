//
//  TaskRepository.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

// further reference: https://peterfriese.dev/posts/firestore-codable-the-comprehensive-guide/
// TODO: ADD DEBOUNCE TO FIREBASE
class TaskRepository: ObservableObject {
    private let path: String = "tasks"
    private let collectionRef: CollectionReference
    private let userId: String
    private let db = Firestore.firestore()
    
    @Published var tasks: [SchoolTask] = []
    @Published var errorMessage: String?
    
    init() {
        let uid = Auth.auth().currentUser?.uid
        guard let uid else {
            fatalError("userId invalid")
        }
        
        userId = uid
        collectionRef = db.collection("users").document(userId).collection(path)
        
        loadTasks()
    }
    
    func loadTasks() {
        collectionRef
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No tasks yet"
                    return
                }
                self?.tasks = documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: SchoolTask.self) }
                    
                    switch result {
                    case .success(let task):
                        self?.errorMessage = nil
                        return task
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
    
    func addTask(_ task: SchoolTask) {
        do {
            var userTask = task
            userTask.userId = userId
            let newDocReference = try collectionRef.addDocument(from: userTask)
            print("Task stored with new document reference: \(newDocReference)")
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateTask(_ task: SchoolTask) {
        if let id = task.id {
            let docRef = collectionRef.document(id)
            do {
                try docRef.setData(from: task)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func removeTask(_ task: SchoolTask) {
        guard let id = task.id else { return }
        let docRef = collectionRef.document(id)
        
        docRef.delete { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
