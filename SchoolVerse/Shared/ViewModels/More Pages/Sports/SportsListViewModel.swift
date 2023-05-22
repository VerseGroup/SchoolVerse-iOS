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
    @Published private var repo = SportsRepository()
    @Published private var api: APIService = Resolver.resolve()

    @Published var allSports = [Sport]()
    @Published var allSportsEvents = [SportsEvent]()
    @Published var selectedAllSportsEvents = [SportsEvent]()
    
    @Published var subscribedSports = [Sport]()
    @Published var subscribedSportsEvents = [SportsEvent]()
    @Published var selectedSubscribedSportsEvents = [SportsEvent]()
    
    @Published var selectedDate: Date = Date()
    @Published var selectedWeek: [Date] = []
    
    @Published var hasError: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        // fixes bug where on first appear of the view, selected sports isnt seen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateSelectedDay(date: Date())
        }
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
        
        // updates subscribed sports
        repo.$subscribedSports
            .sink { [weak self] (returnedSports) in
                self?.subscribedSports = returnedSports
            }
            .store(in: &cancellables)
        
        $subscribedSports
            .sink { returnedSports in
                self.subscribedSportsEvents = returnedSports.flatMap({ sport in
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
        
        // sets selectedAllSportsEvents to the selectedDate
        $selectedDate
            .sink{ (date) in
                self.selectedAllSportsEvents = self.allSportsEvents.filter({ sportEvent in
                    sportEvent.start.calendarDistance(from: date, resultIn: .day) == 0
                }).sorted(by: { one, two in
                    one.start < two.start
                })
            }
            .store(in: &cancellables)
        
        // sets selectedSubscribedSportsEvents to the selectedDate
        $selectedDate
            .sink{ (date) in
                self.selectedSubscribedSportsEvents = self.subscribedSportsEvents.filter({ sportEvent in
                    sportEvent.start.calendarDistance(from: date, resultIn: .day) == 0
                }).sorted(by: { one, two in
                    one.start < two.start
                })
            }
            .store(in: &cancellables)
        
        $selectedDate
            .sink{ (date) in
                self.getSelectedWeek(date: date)
            }
            .store(in: &cancellables)
    }
    
    func updateSelectedDay(date: Date) {
        selectedDate = date
    }
    
    func getSelectedWeek(date: Date) {
        let week = Calendar.current.dateInterval(of: .weekOfMonth, for: date)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        selectedWeek = []
        
        (0..<7).forEach { day in
            if let weekday = Calendar.current.date(byAdding: .day, value: day, to: firstWeekDay) {
                selectedWeek.append(weekday)
            }
        }
    }
    
    func addSport(_ sport: Sport) {
        repo.addSport(sport.id)
    }
    
    func removeSport(_ sport: Sport) {
        repo.removeSport(sport.id)
    }
}
