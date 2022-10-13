//
//  EventsListViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation
import Combine

// read doc where(date = selectedDate)
class EventsListViewModel: ObservableObject {
    private let repo = EventRepository()
    @Published var events = [Event]()
    @Published var errorMessage: String?
    
    @Published var selectedEvents = [Event]()
    
    @Published var selectedDate: Date = Date()
    @Published var selectedWeek: [Date] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        // fixes bug where on first appear of the view, selected events isnt seen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateSelectedDay(date: Date())
        }
    }
    
    func addSubscribers() {
        
        // updates event cell view model
        repo.$events
            .sink { [weak self] (returnedEvents) in
                self?.events = returnedEvents
            }
            .store(in: &cancellables)
        
        // update when events changes based on the selected day
        $events.combineLatest($selectedDate)
            .sink { (events, date) in
                self.selectedEvents = events.filter({ event in
                    event.day.calendarDistance(from: date, resultIn: .day) == 0
                }).sorted(by: { one, two in
                    one.day < two.day
                })
            }
            .store(in: &cancellables)
        
        // updates error message
        repo.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage
            }
            .store(in: &cancellables)
    }
    
    func updateSelectedDay(date: Date) {
        selectedDate = date
        repo.loadEvents(date: date)
    }
}
