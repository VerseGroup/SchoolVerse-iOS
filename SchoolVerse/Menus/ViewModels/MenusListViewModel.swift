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
    
    @Published var selectedMenu: SchoolMenu?
    
    @Published var selectedDate: Date = Date()
    @Published var selectedWeek: [Date] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getSelectedWeek()
        addSubscribers()
        // fixes bug where on first appear of the view, selected menu isnt seen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateSelectedMenu(date: Date())
        }
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
        
        // sets selectedMenu to the current day ***on init***
        $menus
            .sink { (dayEvents) in
                self.selectedMenu = self.menus.first(where: { menu in
                    Calendar.current.isDateInToday(menu.date)
                }) ?? nil
            }
            .store(in: &cancellables)
        
        // sets selectedMenu to the selectedDate
        // sets selectedWeek to the selectedDate
        $selectedDate
            .sink{ (date) in
                print("Called selected date $")
                print(self.menus.capacity)
                self.getSelectedWeek()
                self.selectedMenu = self.menus.first(where: { menu in
                    Calendar.current.isDate(menu.date, equalTo: date, toGranularity: .day)
                }) ?? nil
            }
            .store(in: &cancellables)
    }
    
    func getSelectedWeek() {
        let week = Calendar.current.dateInterval(of: .weekOfMonth, for: selectedDate)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (0..<7).forEach { day in
            if let weekday = Calendar.current.date(byAdding: .day, value: day, to: firstWeekDay) {
                selectedWeek.append(weekday)
                print(weekday)
            }
        }
    }
    
    func updateSelectedMenu(date: Date) {
        selectedDate = date
    }
}
