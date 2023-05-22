//
//  SportsCellViewModel.swift
//  SchoolVerse
//
//  Created by Steven Yu on 3/11/23.
//

import Foundation
import Combine
import Resolver

class SportsCellViewModel: ObservableObject, Identifiable {
    @Published private var repo: SportsRepository = Resolver.resolve()
    @Published var sport: Sport
    @Published var joined: Bool
    
    var id = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sport: Sport) {
        self.sport = sport
        self.joined = true
        
        checkStatus()
        addSubscribers()
    }
    
    func checkStatus() {
        if repo.subscribedSports.contains(where: { $0.id ==  sport.id }) {
            joined = true
        } else {
            joined = false
        }
    }
    
    func addSubscribers() {
        
        // update sport id (for Identifiable)
        $sport
            .compactMap { sport in
                sport.id
            }
            .sink { [weak self] (id) in
                self?.id = id
            }
            .store(in: &cancellables)
        
        // updates sport when event happens
        $sport
            .dropFirst()
            .debounce(for: 1.2, scheduler: RunLoop.main) // ensures changes aren't published immediately, have to wait 1.2 seconds
            .sink { sport in
                self.updateSport()
            }
            .store(in: &cancellables)
    }
    
    func updateSport() {
        if joined {
            removeSport()
        } else {
            addSport()
        }
    }
    
    func addSport() {
        repo.addSport(sport.id)
    }
    
    func removeSport() {
        repo.removeSport(sport.id)
    }
}
