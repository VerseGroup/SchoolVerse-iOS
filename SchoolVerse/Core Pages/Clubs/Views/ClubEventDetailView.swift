//
//  ClubEventDetailView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/17/23.
//

import SwiftUI

struct ClubEventDetailView: View {
    @EnvironmentObject var vm: ClubViewModel
    
    @State var clubEvent: ClubEvent
    
    @State var validTitle: Bool = false
    @State var validLocation: Bool = false
    
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView {
                VStack(spacing: 10) {
                    Spacer()
                        .frame(height: 15)
                    
                    Group {
                        HeaderLabel(name: "Title")
                            .padding(.leading, 5)
                        
                        CustomTextField(placeholder: "Enter a club event title", text: $clubEvent.title)
                            .warningAccessory($clubEvent.title, valid: $validTitle, warning: "Invalid Title") { title in
                                isNotEmpty(text: title)
                            }
                            .padding(.horizontal)
                    }
                    
                    Group {
                        HeaderLabel(name: "Description")
                            .padding(.leading, 5)
                        
                        CustomTextEditor(text: $clubEvent.description)
                            .frame(height: 200)
                            .padding()
                    }
                    
                    Group {
                        HeaderLabel(name: "Location")
                            .padding(.leading, 5)
                        
                        CustomTextField(placeholder: "Enter a club event location", text: $clubEvent.location)
                            .warningAccessory($clubEvent.location, valid: $validLocation, warning: "Invalid Location") { location in
                                isNotEmpty(text: location)
                            }
                            .padding(.horizontal)
                    }
                    
                    Group {
                        HeaderLabel(name: "Time")
                            .padding(.leading, 5)
                        
                        DatePicker(selection: $clubEvent.start, displayedComponents: [.date, .hourAndMinute]) {
                            Text("Start Date")
                                .padding(.leading)
                        }
                        .tint(accentColor)
                        .padding(10)
                        .glass()
                        .padding(.horizontal)
                        
                        DatePicker(selection: $clubEvent.end, displayedComponents: [.date, .hourAndMinute]) {
                            Text("End Date")
                                .padding(.leading)
                        }
                        .tint(accentColor)
                        .padding(10)
                        .glass()
                        .padding(.horizontal)
                    }
                }
            }
            
        }
        .navigationTitle("Club Event Details")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    vm.deleteClubEvent(clubEvent: clubEvent)
                    dismiss()
                } label: {
                    NavButtonView(systemName: "trash")
                }
                
                Button {
                    vm.updateClubEvent(clubEvent: clubEvent)
                    dismiss()
                } label: {
                    NavButtonView(systemName: "externaldrive.badge.checkmark")
                        .opacity((clubEvent.title.isEmpty || clubEvent.location.isEmpty) ? 0.25 : 1)
                }
                .disabled(clubEvent.title.isEmpty || clubEvent.location.isEmpty)
            }
        }
    }
}
