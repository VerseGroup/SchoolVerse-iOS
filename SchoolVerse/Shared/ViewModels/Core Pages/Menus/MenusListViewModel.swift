//
//  MenusListViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation
import Combine

class MenusListViewModel: ObservableObject {
    @Published private var repo = MenusRepository()
    @Published var menus = [SchoolMenu]()
    @Published var errorMessage: String?
    
    @Published var selectedMenu: SchoolMenu?
    
    @Published var weekStore: WeekStore = WeekStore()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        // fixes bug where on first appear of the view, selected menu isnt seen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.weekStore.selectToday()
            self.repo.loadMenus(date: Date())
        }
    }
    
    func addSubscribers() {
        
        // updates menu cell view models
        repo.$menus
            .sink { [weak self] (returnedMenus) in
                self?.menus = returnedMenus
            }
            .store(in: &cancellables)
        
        
        // update when menus changes based on the selected day
        $menus.combineLatest(weekStore.$selectedDate)
            .sink { (menus, date) in
                self.selectedMenu = menus.first(where: { menu in
                    Calendar.current.isDate(menu.date, equalTo: date, toGranularity: .day)
                }) ?? nil
            }
            .store(in: &cancellables)
        
        // updates error message
        repo.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage
            }
            .store(in: &cancellables)
        
        weekStore.$selectedDate
            .sink { date in
                self.repo.loadMenus(date: date)
            }
            .store(in: &cancellables)
        
    }
    
}
