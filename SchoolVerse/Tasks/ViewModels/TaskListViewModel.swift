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

class TaskListViewModel: ObservableObject {
    @ObservedObject private var repo: TaskRepository = Resolver.resolve()
    @Published var taskCellViewModels = [TaskCellViewModel]()
    @Published var errorMessage: String?
    
    @InjectedObject private var api: APIService
    @Published var apiStatus: Bool = false
    @Published var scrapeResponse: ScrapeResponse?
    
    @Published var showBanner: Bool = false
    @Published var bannerTitle: String = ""
    @Published var bannerDetail: String? = nil
    
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // firebase vars
        
        // updates task cell view models
        repo.$tasks
            .map { tasks in
                tasks.map { task in
                    print("vm" + task.name)
                    return TaskCellViewModel(task: task)
                }
            }
            .sink { [weak self] (returnedTaskCellVMs) in
                self?.taskCellViewModels = returnedTaskCellVMs
            }
            .store(in: &cancellables)
        
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
    
    private let debouncer = Debouncer(timeInterval: 10)
    
    // don't scrape too much (MONEY!!!!!)
    func scrape() {
        debouncer.renewInterval()
        debouncer.handler = {
            self.isLoading = true
            self.repo.removeListener()
            self.api.scrape()
            // might need to change the DispatchQueue to match the api scrape
            // TODO: find a way to know when request is finished and then call addlistener()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.repo.addListener()
                self.isLoading = false
            }
        }
    }
}
