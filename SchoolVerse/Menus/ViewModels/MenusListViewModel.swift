//
//  MenusListViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation
import Combine

class MenusListViewModel: ObservableObject {
    private let repo = MenusRepository()
    @Published var menus = [SchoolMenu]()
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // updates menu cell view models
        repo.$menus
            .sink { [weak self] (returnedMenus) in
                self?.menus = returnedMenus
            }
            .store(in: &cancellables)
        
        // updates error message
        repo.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage
            }
            .store(in: &cancellables)
    }
}
