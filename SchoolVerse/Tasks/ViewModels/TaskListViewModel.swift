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
    @ObservedObject private var repo: TaskRepository = Resolver.resolve()
    //    @Published var taskCellViewModels = [TaskCellViewModel]()
    
    @Published var previousTasks = [SchoolTask]()
    @Published var currentTasks = [SchoolTask]()
    @Published var futureTasks = [SchoolTask]()
    
    @Published var previousTaskCellViewModels = [TaskCellViewModel]()
    @Published var currentTaskCellViewModels = [TaskCellViewModel]()
    @Published var futureTaskCellViewModels = [TaskCellViewModel]()
    
    @Published var tasksDictionary: [String: [SchoolTask]] = [:]
    
    @Published var errorMessage: String?
    
    @InjectedObject private var api: APIService
    @Published var apiStatus: Bool = false
    @Published var scrapeResponse: ScrapeResponse?
    
    @Published var showBanner: Bool = false
    @Published var bannerTitle: String = ""
    @Published var bannerDetail: String? = nil
    
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isAvailable: Bool = true
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 200, repeats: true, block: { _ in
            self.isAvailable = true
        })
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // firebase vars
        
        // creates task dictionary
        repo.$tasks
            .sink { [weak self] (returnedTasks) in
                var dict = Dictionary(grouping: returnedTasks, by: { (element: SchoolTask) in
                    return element.courseName
                })
                withAnimation(.default) {
                    self?.tasksDictionary = dict.mapValues { tasks in
                        return tasks.sorted(by: {
                            if $0.completed != $1.completed {
                                return !$0.completed
                            } else {
                                return $0.dueDate < $1.dueDate
                            }
                        })
                    }
                }
                print("Dictionary")
                print(self?.tasksDictionary)
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
            }
            .store(in: &cancellables)
        
        // api vars
        
        api.$status
            .sink { [weak self] (returnedStatus) in
                self?.apiStatus = returnedStatus
                
                self?.bannerTitle = "API is \(returnedStatus ? "online" : "offline")!"
                self?.showBanner = true
            }
            .store(in: &cancellables)
        
        api.$scrapeResponse
            .sink { [weak self] (returnedScrapeResponse) in
                self?.scrapeResponse = returnedScrapeResponse
            }
            .store(in: &cancellables)
        
        // dismisses after 5 seconds
        $scrapeResponse
            .debounce(for: .seconds(5), scheduler: RunLoop.main)
            .sink { _ in
                self.scrapeResponse = nil
            }
            .store(in: &cancellables)
        
    }
    
    // checks if API is online
    func pingAPI() {
        api.ping()
    }
    
    func scrape() {
        if isAvailable {
            self.isAvailable = false
            self.isLoading = true
            self.repo.removeListener()
            self.api.scrape(completion: { scrapeResponse in
                self.repo.addListener()
                self.isLoading = false
            })
        } else {
            print("WAIT! Is not available")
        }
    }
    
//    private let debouncer = Debouncer(timeInterval: 200)
    
//    func scrape() {
//        debouncer.renewInterval()
//        debouncer.handler = {
//            self.isLoading = true
//            self.repo.removeListener()
//            self.api.scrape(completion: { scrapeResponse in
//                self.repo.addListener()
//                self.isLoading = false
//            })
//        }
//    }
}
