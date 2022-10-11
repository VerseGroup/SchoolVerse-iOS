//
//  EventsListViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import Foundation
import Combine

class EventsListViewModel: ObservableObject {
    private let repo = EventRepository()
    @Published var events = [Event]()
    @Published var errorMessage: String?
    
    @Published var selectedEvents = [Event]()
    
    @Published var selectedDate: Date
    @Published var selectedWeek: [Date] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        selectedDate = Date()
        getSelectedWeek()
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // updates event cell view model
        repo.$events
            .sink { [weak self] (returnedEvents) in
                self?.events = returnedEvents
            }
            .store(in: &cancellables)
        
        // updates error message
        repo.$errorMessage
            .sink { [weak self] (returnedErrorMessage) in
                self?.errorMessage = returnedErrorMessage
            }
            .store(in: &cancellables)
        
        
        // sets selectedWeek to the selectedDate
        $selectedDate
            .sink{ (date) in
                self.getSelectedWeek()
                self.selectedEvents = self.events.filter({ event in
                    event.day.calendarDistance(from: date, resultIn: .day) == 0
                }).sorted(by: { one, two in
                    one.day < two.day
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
