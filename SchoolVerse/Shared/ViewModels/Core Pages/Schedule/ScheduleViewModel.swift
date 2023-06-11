//
//  ScheduleViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/9/22.
//

import Foundation
import Combine
import Resolver

class ScheduleViewModel: ObservableObject {
    @Published private var repo: ScheduleRepository = Resolver.resolve()
    @Published var errorMessage: String?
    
    @Published var dayEvents: [DayEvent] = []
    @Published var schedule: Schedule?
    
    @Published var selectedDayEvent: DayEvent?
    
    @Published var weekStore: WeekStore = WeekStore()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.weekStore.selectToday()
        }
    }
    
    func addSubscribers() {
        repo.$dayEvents
            .sink { [weak self] (returnedDayEvents) in
                self?.dayEvents = returnedDayEvents
//                print(self?.dayEvents.debugDescription)
            }
            .store(in: &cancellables)
        
        repo.$schedule
            .sink { [weak self] (returnedSchedule) in
                self?.schedule = returnedSchedule
            }
            .store(in: &cancellables)
        
        // sets selectedDayEvent to the current day ***on init***
        $dayEvents
            .sink { (dayEvents) in
                self.selectedDayEvent = dayEvents.first(where: { dayEvent in
                    Calendar.current.isDateInToday(dayEvent.date)
                }) ?? nil
            }
            .store(in: &cancellables)
        
        // sets selectedDayEvent to the selectedDate
        weekStore.$selectedDate
            .sink{ (date) in
                self.selectedDayEvent = self.dayEvents.first(where: { dayEvent in
                    Calendar.current.isDate(dayEvent.date, equalTo: date, toGranularity: .day)
                }) ?? nil
            }
            .store(in: &cancellables)
        
    }
    
//    func updateSelectedDayEvent(date: Date) {
//        weekStore.selectedDate = date
//    }
}
