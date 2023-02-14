//
//  TaskListViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import Foundation
import Combine
import Resolver
import SwiftUI
import Collections

class TaskListViewModel: ObservableObject {
    @Published private var repo: TaskRepository = Resolver.resolve()
    //    @Published var taskCellViewModels = [TaskCellViewModel]()
    
    @Published var previousTasks = [SchoolTask]()
    @Published var currentTasks = [SchoolTask]()
    @Published var futureTasks = [SchoolTask]()
    
    @Published var previousTaskCellViewModels = [TaskCellViewModel]()
    @Published var currentTaskCellViewModels = [TaskCellViewModel]()
    @Published var futureTaskCellViewModels = [TaskCellViewModel]()
    
    @Published var tasksClassDictionary: [String: [SchoolTask]] = [:]
    @Published var tasksDateDictionary: [Date: [SchoolTask]] = [:]
    
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    @Published private var api: APIService = Resolver.resolve()
    @Published var apiStatus: Bool = false
    @Published var getDataResponse: GetDataResponse?
    
    @Published var showBanner: Bool = false
    @Published var bannerTitle: String = ""
    @Published var bannerDetail: String? = nil
    
    @Published var taskSortLocal: TaskSort = .sortUrgency
    //@AppStorage("task_sort_preference") var taskSort: TaskSort = .sortUrgency
    
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isAvailable: Bool = true
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 200, repeats: true, block: { _ in
            self.isAvailable = true
        })
        //taskSortLocal = taskSort
        addSubscribers()
    }
    
    func addSubscribers() {
        
//        $taskSortLocal
//            .sink { (returnedSort) in
//                self.taskSort = returnedSort
//            }
//            .store(in: &cancellables)
        
        // firebase vars
        
        // creates task class dictionary
        repo.$tasks
            .sink { [weak self] (returnedTasks) in
                let dict = Dictionary(grouping: returnedTasks, by: { (element: SchoolTask) in
                    return element.courseName
                })
                withAnimation(.default) {
                    self?.tasksClassDictionary = dict.mapValues { tasks in
                        return tasks.sorted(by: {
                            if $0.completed != $1.completed {
                                return !$0.completed
                            } else {
                                return $0.dueDate < $1.dueDate
                            }
                        })
                    }
                }
            }
            .store(in: &cancellables)
        
        // creates task date dictionary
        repo.$tasks
            .sink { [weak self] (returnedTasks) in
                let dict = Dictionary(grouping: returnedTasks, by: { (element: SchoolTask) in
                    return element.dueDate.startOfDay
                })
                withAnimation(.default) {
                    self?.tasksDateDictionary = dict.mapValues { tasks in
                        return tasks.sorted(by: {
                            if $0.completed != $1.completed {
                                return !$0.completed
                            } else {
                                return $0.dueDate < $1.dueDate
                            }
                        })
                    }
                }
            }
            .store(in: &cancellables)
        
        // creates previous tasks
        repo.$tasks
            .map{ tasks in
                tasks.filter { task in
                    return Date.now.calendarDistance(from: task.dueDate, resultIn: .day) < 0
                }
            }
            .sink { [weak self] (returnedTasks) in
                let tasks = returnedTasks.sorted(by: {
                    if $0.completed != $1.completed {
                        return !$0.completed
                    } else {
                        return $0.dueDate < $1.dueDate
                    }
                })
                withAnimation(.default) {
                    self?.previousTasks = tasks
                }
                //                print("previous tasks")
                //                for task in tasks {
                //                    print(task.name + task.dueDate.weekDateTimeString())
                //                }
            }
            .store(in: &cancellables)
        
        // creates previous tasks vm
//        $previousTasks
//            .map { tasks in
//                tasks.map { task in
//                    return TaskCellViewModel(task: task)
//                }
//            }
//            .sink { [weak self] (returnedTaskCellVMs) in
//                self?.previousTaskCellViewModels = returnedTaskCellVMs
//            }
//            .store(in: &cancellables)
        
        // creates current tasks
        repo.$tasks
            .map { tasks in
                tasks.filter { task in
                    return (Date.now.calendarDistance(from: task.dueDate, resultIn: .day) == 0 || Date.now.calendarDistance(from: task.dueDate, resultIn: .day) == 1)
                }
            }
            .sink { [weak self] (returnedTasks) in
                let tasks = returnedTasks.sorted(by: {
                    if $0.completed != $1.completed {
                        return !$0.completed
                    } else {
                        return $0.dueDate < $1.dueDate
                    }
                })
                withAnimation(.default) {
                    self?.currentTasks = tasks
                }
                //                print("current tasks")
                //                for task in tasks {
                //                    print(task.name + task.dueDate.weekDateTimeString())
                //                }
            }
            .store(in: &cancellables)
        
        // creates current tasks vm
//        $currentTasks
//            .map { tasks in
//                tasks.map { task in
//                    return TaskCellViewModel(task: task)
//                }
//            }
//            .sink { [weak self] (returnedTaskCellVMs) in
//                self?.currentTaskCellViewModels = returnedTaskCellVMs
//            }
//            .store(in: &cancellables)
        
        // creates future tasks
        repo.$tasks
            .map{ tasks in
                tasks.filter { task in
                    return Date.now.calendarDistance(from: task.dueDate, resultIn: .day) > 1
                }
            }
            .sink { [weak self] (returnedTasks) in
                let tasks = returnedTasks.sorted(by: {
                    if $0.completed != $1.completed {
                        return !$0.completed
                    } else {
                        return $0.dueDate < $1.dueDate
                    }
                })
                withAnimation(.default) {
                    self?.futureTasks = tasks
                }
                print("future tasks")
                for task in tasks {
                    print(task.name + task.dueDate.weekDateTimeString())
                }
            }
            .store(in: &cancellables)
        
        // creates future tasks vm
//        $futureTasks
//            .map { tasks in
//                tasks.map { task in
//                    return TaskCellViewModel(task: task)
//                }
//            }
//            .sink { [weak self] (returnedTaskCellVMs) in
//                self?.futureTaskCellViewModels = returnedTaskCellVMs
//            }
//            .store(in: &cancellables)
        
        // updates error message
        repo.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage

                if returnedErrorMessage != nil {
                    self?.hasError = true
                }
            }
            .store(in: &cancellables)
        
        // api vars
        
        api.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage

                if returnedErrorMessage != nil {
                    self?.hasError = true
                }
            }
            .store(in: &cancellables)
        
        api.$status
            .sink { [weak self] (returnedStatus) in
                self?.apiStatus = returnedStatus
                
                self?.bannerTitle = "API is \(returnedStatus ? "online" : "offline")!"
                self?.showBanner = true
            }
            .store(in: &cancellables)
        
        api.$getDataResponse
            .sink { [weak self] (returnedGetDataResponse) in
                self?.getDataResponse = returnedGetDataResponse
            }
            .store(in: &cancellables)
        
        // dismisses after 5 seconds
        $getDataResponse
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.getDataResponse = nil
            }
            .store(in: &cancellables)
        
    }
    
    // checks if API is online
    func pingAPI() {
        api.ping()
    }
    
    func getData() {
        if isAvailable {
            self.isAvailable = false
            withAnimation(.spring()) {
                self.isLoading = true
            }
            self.repo.removeListener()
            self.api.getData(completion: { getDataResponse in
                self.repo.addListener()
                withAnimation(.spring()) {
                    self.isLoading = false
                }
            })
        } else {
            print("WAIT! Is not available")
        }
    }
    
    func changeTaskSort(sort: TaskSort) {
        taskSortLocal = sort
    }
    
//    private let debouncer = Debouncer(timeInterval: 200)
    
//    func getData() {
//        debouncer.renewInterval()
//        debouncer.handler = {
//            self.isLoading = true
//            self.repo.removeListener()
//            self.api.getData(completion: { getDataResponse in
//                self.repo.addListener()
//                self.isLoading = false
//            })
//        }
//    }
}
