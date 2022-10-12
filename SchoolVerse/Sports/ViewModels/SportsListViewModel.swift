//
//  SportsListViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation
import Combine
import Resolver

class SportsListViewModel: ObservableObject {
    private let repo = SportsRepository()
    @InjectedObject private var api: APIService
    
    @Published var allSports = [Sport]()
    @Published var allSportsEvents = [SportsEvent]()
    @Published var selectedAllSportsEvents = [SportsEvent]()
    
    @Published var selectedDate: Date
    @Published var selectedWeek: [Date] = []
    
    @Published var hasError: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        selectedDate = Date()
        getSelectedWeek()
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // updates all sports
        repo.$sports
            .sink { [weak self] (returnedSports) in
                self?.allSports = returnedSports
            }
            .store(in: &cancellables)
        
        // updates all sports events
        $allSports
            .sink { returnedSports in
                self.allSportsEvents = returnedSports.flatMap({ sport in
                    sport.events
                })
            }
            .store(in: &cancellables)
        
        // updates error message
        repo.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage
                
                if returnedErrorMessage != nil {
                    self?.hasError = true
                }
            }
            .store(in: &cancellables)
        
        
        api.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage
                
                if returnedErrorMessage != nil {
                    self?.hasError = true
                }
            }
            .store(in: &cancellables)
        
        // sets selectedWeek to the selectedDate
        $selectedDate
            .sink{ (date) in
                self.getSelectedWeek()
                self.selectedAllSportsEvents = self.allSportsEvents.filter({ sportEvent in
                    sportEvent.start.calendarDistance(from: date, resultIn: .day) == 0
                }).sorted(by: { one, two in
                    one.start < two.start
                })
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
    
    func updateSelectedDay(date: Date) {
        selectedDate = date
    }
}
