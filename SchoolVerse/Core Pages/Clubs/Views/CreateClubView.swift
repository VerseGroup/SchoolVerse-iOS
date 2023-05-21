//
//  CreateClubView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/17/23.
//

import SwiftUI

struct CreateClubView: View {
    @ObservedObject var vm: ClubsViewModel
    
    @State var club: Club = Club(id: "", name: "", description: "", leaderIds: [], leaderNames: [], memberIds: [], memberNames: [], groupNotice: "", groupNoticeLastUpdated: Date.now, groupNoticeAuthor: "", status: false, clubEvents: [])
    
    @State var validName: Bool = false
    @State var validDescription: Bool = false
    
    enum Field: Hashable {
        case name
        case description
    }
    
    @FocusState private var focusedField: Field?

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack(spacing: 10) {
                Spacer()
                    .frame(height: 75)
                
                HeaderLabel(name: "Name")
                    .padding(.leading, 5)
                
                CustomTextField(placeholder: "Enter a club name", text: $club.name)
                    .focused($focusedField, equals: .name)
                    .warningAccessory($club.name, valid: $validName, warning: "Invalid Name") { name in
                        isNotEmpty(text: name)
                    }
                    .padding(.horizontal)

                
                HeaderLabel(name: "Description")
                    .padding(.leading, 5)
                
                CustomTextEditor(text: $club.description)
                    .focused($focusedField, equals: .description)
                    .frame(height: 250)
                    .warningAccessory($club.description, valid: $validDescription, warning: "Invalid Description") { description in
                        isNotEmpty(text: description)
                    }
                    .padding()
                
                Button {
                    vm.createClub(club)
                    dismiss()
                } label: {
                    Text("Create Club")
                        .foregroundColor(Color.white)
                        .padding()
                        .padding(.horizontal)
                        .glassCardFull()
                        .opacity((club.name.isEmpty || club.description.isEmpty) ? 0.25 : 1)
                }
                .disabled(club.name.isEmpty || club.description.isEmpty)

                Spacer()
            }
        }
        .navigationTitle("Create New Club")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button {
                    focusedField = nil
                } label: {
                    Text("Done")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .glass()
                }
            }
        }
    }
}
