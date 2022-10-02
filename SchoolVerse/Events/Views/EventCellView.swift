//
//  EventCellView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct EventCellView: View {
    let event: Event
    @State var showEventDetailView: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.start.weekDateTimeString())
                Text(event.name)
                    .font(.title2)
                    .bold()
                Text(event.description)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .background(Color.purple)
        .cornerRadius(10)
        .sheet(isPresented: $showEventDetailView) {
            EventDetailView(event: event)
        }
        .onTapGesture {
            showEventDetailView.toggle()
        }
    }
}

struct EventCellView_Previews: PreviewProvider {
    static var previews: some View {
        EventCellView(event: Event(id: "uuid", name: "Name of Event", description: "This is a description of an event.", location: "School", start: Date(), end: Date()))
    }
}
