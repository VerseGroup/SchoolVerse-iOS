//
//  ClubsViewModel.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/7/23.
//

import Foundation
import Combine
import Resolver

class ClubsViewModel: ObservableObject {
    @Published var myClubs: [Club] = []
    @Published var joinedCLubs: [Club] = []
    @Published var allClubs: [Club] = []
    
    @Published var searchText: String = ""
    
    @Published var selectedDate: Date = Date()
    @Published var selectedWeek: [Date] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateSelectedDayEvent(date: Date())
        }
    }
    
    func addSubscribers() {
        $selectedDate
            .sink{ (date) in
                self.getSelectedWeek(date: date)
            }
            .store(in: &cancellables)
    }
    
    func updateSelectedDayEvent(date: Date) {
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
}
