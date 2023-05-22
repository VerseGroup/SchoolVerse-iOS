//
//  ClubViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/16/23.
//

import Foundation
import Combine
import Resolver

class ClubViewModel: ObservableObject, Identifiable {
    @Published private var repo: ClubsRepository = Resolver.resolve()
    @Published var club: Club
    @Published var inClub: Bool = false
    @Published var isLeader: Bool = false
    
    var id: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(club: Club) {
        self.club = club
        
        checkJoined()
        checkLeader()
        
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // update club id (for identifiable)
        $club
            .compactMap { club in
                club.id
            }
            .sink { [weak self] (id) in
                self?.id = id
            }
            .store(in: &cancellables)
        
        // automatically checks if club is in joinedClubs when joinedClubs changes
        repo.$joinedClubs
            .sink { _ in
                self.checkJoined()
            }
            .store(in: &cancellables)
    }
    
    func checkJoined() {
        inClub = repo.joinedClubs.contains(where: {$0.id == club.id})
    }
    
    func checkLeader() {
        isLeader = club.leaderIds.contains(repo.userId)
    }
    
    // add CRUD club event functions and announce
    
    func joinClub() {
        repo.joinClub(club)
    }
    
    func leaveClub() {
        repo.leaveClub(club)
    }
    
    func deleteClub() {
        repo.deleteClub(club)
    }
    
    func announceClub(announcement: String) {
        repo.announceClub(club: club, announcement: announcement)
    }
    
    func createClubEvent(clubEvent: ClubEvent) {
        let editedClubEvent = ClubEvent(id: clubEvent.id, clubId: club.id, title: clubEvent.title, description: clubEvent.description, location: clubEvent.location, start: clubEvent.start, end: clubEvent.end)
        repo.createClubEvent(clubEvent: editedClubEvent)
    }
    
    func updateClubEvent(clubEvent: ClubEvent) {
        repo.updateClubEvent(clubEvent: clubEvent)
    }
    
    func deleteClubEvent(clubEvent: ClubEvent) {
        repo.deleteClubEvent(clubEvent: clubEvent)
    }
    
}
