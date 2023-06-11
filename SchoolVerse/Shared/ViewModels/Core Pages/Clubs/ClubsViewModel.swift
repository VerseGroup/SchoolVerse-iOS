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
    @Published private var repo = ClubsRepository()
    @Published private var api: APIService = Resolver.resolve()
    
    @Published var allClubs = [Club]()
        
    @Published var joinedClubs = [Club]()
    
    // calendar section
    @Published var joinedClubsEvents = [ClubEvent]()
    @Published var selectedJoinedClubsEvents = [ClubEvent]()
    
    @Published var weekStore: WeekStore = WeekStore()
    
    @Published var hasError: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
        // fixes bug where on first appear of the view, selected clubs isn't seen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.weekStore.selectToday()
        }
    }
    
    func addSubscribers() {
        
        // updates all clubs
        repo.$clubs
            .sink { [weak self] (returnedClubs) in
                self?.allClubs = returnedClubs.sorted(by: { one, two in
                    one.name < two.name
                })
            }
            .store(in: &cancellables)
        
        // updates joinedClubs
        repo.$joinedClubs
            .sink { [weak self] (returnedClubs) in
                self?.joinedClubs = returnedClubs
            }
            .store(in: &cancellables)
        
        // updates joined clubs events
        $joinedClubs
            .sink { returnedClubs in
                self.joinedClubsEvents = returnedClubs.flatMap({ club in
                    club.clubEvents
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
        
        // sets selectedJoinedClubsEvents to the selectedDate
        weekStore.$selectedDate
            .sink { (date) in
                self.selectedJoinedClubsEvents = self.joinedClubsEvents.filter({ clubEvent in
                    clubEvent.start.calendarDistance(from: date, resultIn: .day) == 0
                }).sorted(by: { one, two in
                    one.start < two.start
                })
            }
            .store(in: &cancellables)
        
    }
    
    func createClub(_ club: Club) {
        repo.createClub(club)
    }
    
    func joinClub(_ club: Club) {
        repo.joinClub(club)
    }
    
    func leaveClub(_ club: Club) {
        repo.leaveClub(club)
    }
    
}
