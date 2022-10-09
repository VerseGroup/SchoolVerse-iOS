//
//  TaskCellViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import Foundation
import Combine
import Resolver
import SwiftUI

class TaskCellViewModel: ObservableObject, Identifiable {
    @ObservedObject private var repo: TaskRepository = Resolver.resolve()
    @Published var task: SchoolTask
    
    var id: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(task: SchoolTask) {
        self.task = task
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // update task id (for Identifiable)
        $task
            .compactMap { task in
                task.id
            }
            .sink { [weak self] (id) in
                self?.id = id
            }
            .store(in: &cancellables)
        
        // updates task when event happens
        $task
            .dropFirst()
            .debounce(for: 1.2, scheduler: RunLoop.main) // ensures changes aren't published immediately, have to wait 1.2 seconds
            .sink { task in
                self.updateTask()
            }
            .store(in: &cancellables)
    }
    
    func updateTask(_ editedTask: SchoolTask? = nil) {
        if let editedTask {
            task = editedTask
        }
        repo.updateTask(task)
    }
    
    func removeTask() {
        repo.removeTask(task)
    }
}
