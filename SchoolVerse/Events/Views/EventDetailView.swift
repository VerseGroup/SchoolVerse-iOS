//
//  EventDetailView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct EventDetailView: View {
    var event: Event
    
    var body: some View {
        VStack {
            Text(event.name)
            Text(event.description)
            HStack {
                Text(event.start.weekDateTimeString())
                Text(event.end.weekDateTimeString())
            }
            if let location = event.location {
                Text(location)
            }
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: Event(id: "id", name: "Event", description: "Description", location: "Location", start: Date.now, end: Date.now))
    }
}
