//
//  ClubPageView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/10/23.
//

import SwiftUI

// finish
struct ClubPageView: View {
    @ObservedObject var vm: ClubViewModel
    
    @State var clubEvent: ClubEvent = ClubEvent(id: "", clubId: "", title: "", description: "", location: "", start: Date.now, end: Date.now)
    @State var announcement: String = ""
    
    @State var validTitle: Bool = false
    @State var validLocation: Bool = false
    
    @State var validAnnouncement: Bool = false
    
    @State var showCreateClubEventView: Bool = false
    @State var showAnnouncementsView: Bool = false
    @State var showDelete: Bool = false

    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @Namespace var animation
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack() {
                    Spacer()
                        .frame(height: 15)
                    
                    if !vm.club.status {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.headline)

                            Text("Club awaiting approval")
                                .font(.headline)
                        }
                        .padding(.vertical, 5)
                    } else {
                        generalInfo
                        
                        news
                    }
                    
                    Spacer()
                        .frame(height: 95)
                }
            }
        }
        .navigationTitle(vm.club.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                if vm.inClub {
                    if vm.isLeader {
                        if vm.club.status {
                            Button {
                                showCreateClubEventView.toggle()
                            } label: {
                                NavButtonView(systemName: "calendar.badge.plus")
                            }
                            
                            Button {
                                showAnnouncementsView.toggle()
                            } label: {
                                NavButtonView(systemName: "megaphone.fill")
                            }
                        } else {
                            Button {
                                showDelete.toggle()
                            } label: {
                                NavButtonView(systemName: "trash")
                            }
                        }
                    } else {
                        Button {
                            vm.leaveClub()
                            dismiss()
                        } label: {
                            NavButtonView(systemName: "xmark")
                        }
                    }
                } else {
                    Button {
                        vm.joinClub()
                    } label: {
                        NavButtonView(systemName: "plus")
                    }

                }
            })
        }
        .environmentObject(vm)
        .sheet(isPresented: $showCreateClubEventView) {
            createClubEventView
        }
        .sheet(isPresented: $showAnnouncementsView) {
            announcementsView
        }
        .alert(isPresented: $showDelete) {
            Alert(
                title: Text("Are you sure you want to delete this club?"),
                primaryButton: .destructive(Text("Delete Club")) {
                    vm.deleteClub()
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

extension ClubPageView {
    var generalInfo: some View {
        Group {
            ParagraphLabel(name: vm.club.description)
                .padding(.horizontal)
                .padding(.bottom, 7)
            
            HStack {
                
                Text("Leaders: \(vm.club.leaderNames.joined(separator: ", "))")
                    .font(.headline)
                    .padding(.horizontal)
                
                Spacer()
            }
            
            Rectangle()
                .fill(.white)
                .frame(width: UIScreen.main.bounds.width * 5/6, height: 2)
                .padding(.vertical, 5)
            
        }
    }
    
    var news: some View {
        Group {
            if !vm.club.groupNotice.isEmpty {
                HeaderLabel(name: "Announcements")
                    .padding(.leading, 5)

                ClubAnnouncementsTile(postedBy: vm.club.groupNoticeAuthor, announcement: vm.club.groupNotice, time: vm.club.groupNoticeLastUpdated)
                    .padding(.horizontal)
            } else {
                ParagraphLabel(name: "No Announcements")
                    .padding(.horizontal)
            }
            
            HeaderLabel(name: "Upcoming Events")
                .padding(.leading, 5)
            
            
            if !vm.club.clubEvents.filter({ clubEvent in
                clubEvent.start > Date.now
            }).isEmpty {
                ForEach(vm.club.clubEvents.filter({ clubEvent in
                    clubEvent.start > Date.now
                }).sorted(by: { one, two in
                    one.start < two.start
                })) { clubEvent in
                    ClubEventTile(clubEvent: clubEvent)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                }
            } else {
                SubtitleLabel(name: "There are no upcoming events.")
                    .padding(.horizontal)
            }
            
        }
    }
    
    var createClubEventView: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
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
                    
                    Spacer()
                        .frame(height: 25)
                    
                    
                    Button {
                        vm.createClubEvent(clubEvent: clubEvent)
                        dismiss()
                    } label: {
                        Text("Create Club Event")
                            .foregroundColor(Color.white)
                            .padding()
                            .padding(.horizontal)
                            .glassCardFull()
                            .opacity((clubEvent.title.isEmpty || clubEvent.location.isEmpty) ? 0.25 : 1)
                    }
                    .disabled(clubEvent.title.isEmpty || clubEvent.location.isEmpty)
                    
                }
            }
        }
    }
    
    var announcementsView: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack(spacing: 10) {
                Spacer()
                    .frame(height: 15)
                
                HeaderLabel(name: "Update Club Announcement")
                    .padding(.leading, 5)
                
                CustomTextEditor(text: $announcement)
                    .frame(height: 250)
                    .warningAccessory($announcement, valid: $validAnnouncement, warning: "Invalid Announcement") { announcement in
                        isNotEmpty(text: announcement)
                    }
                    .padding()
                
                Spacer()
                    .frame(height: 25)
                
                Button {
                    vm.announceClub(announcement: announcement)
                    dismiss()
                } label: {
                    Text("Update Announcement")
                        .foregroundColor(Color.white)
                        .padding()
                        .padding(.horizontal)
                        .glassCardFull()
                        .opacity(announcement.isEmpty ? 0.25 : 1)
                }
                .disabled(announcement.isEmpty)
                
                Spacer()
            }
        }
    }
}
