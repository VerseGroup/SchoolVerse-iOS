//
//  EventsView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct EventsView: View {
    @StateObject var vm: EventsListViewModel = EventsListViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(vm.events) { event in
                    EventCellView(event: event)
                        .listRowBackground(EmptyView())
                        .listRowSeparator(.hidden)
                }
            }
        }
        .navigationTitle("Events")
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
