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
    
    private var listener: ListenerRegistration?
    
    @Published var tasks: [SchoolTask] = []
    @Published var errorMessage: String?
    
    @Published var courses: [Course] = []
    
    @Published var counter: Int = 0
    
    init() {
        print("Init task repo")
        
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

            collectionRef = db.collection("users").document(userId).collection(path)

            return
        }
        
        userId = uid
        collectionRef = db.collection("users").document(userId).collection(path)
        
        getCourses()
        addListener()
    }
    
    deinit {
        print("Deinit task repo")
    }
    
    func getCourses() {
        db.collection("users").document(userId).getDocument(as: UserModel.self) { [weak self] result in
            switch result {
            case .success(let user):
                self?.courses = user.courses
            case .failure(let error):
                print("Couldn't get courses: \(error.localizedDescription)")
            }
        }
    }
    
    func addListener() {
        listener = collectionRef
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No tasks yet"
                    return
                }
                self?.tasks = documents.compactMap({ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: SchoolTask.self) }
                    
                    switch result {
                    case .success(let task):
                        print("Got task \(task.name)")
                        var numVisited = UserDefaults.standard.integer(forKey: "\(task.name)")
                        print("numVisited for \(task.name): \(numVisited)")
                        numVisited+=1
                        UserDefaults.standard.set(numVisited, forKey: "\(task.name)")
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
                self?.tasks.sort(by: {$0.dueDate < $1.dueDate})
            }
    }
    
    func removeListener() {
        listener?.remove()
    }
    
    // possible solution: detach the snapshot listener when scraping and reattach after finishing listen
//    func loadTasks() {
//        let listener = collectionRef
//            .addSnapshotListener { [weak self] (querySnapshot, error) in
//                guard let documents = querySnapshot?.documents else {
//                    self?.errorMessage = "No tasks yet"
//                    return
//                }
//                self?.tasks = documents.compactMap({ queryDocumentSnapshot in
//                    let result = Result { try queryDocumentSnapshot.data(as: SchoolTask.self) }
//
//                    switch result {
//                    case .success(let task):
//                        print("Got task \(task.name)")
//                        var numVisited = UserDefaults.standard.integer(forKey: "\(task.name)")
//                        print("numVisited for \(task.name): \(numVisited)")
//                        numVisited+=1
//                        UserDefaults.standard.set(numVisited, forKey: "\(task.name)")
//                        return task
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
//    }
    
    func addTask(_ task: SchoolTask) {
        do {
            let newDocReference = try collectionRef.addDocument(from: task)
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
                print("could not update: \(errorMessage ?? "")")
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
