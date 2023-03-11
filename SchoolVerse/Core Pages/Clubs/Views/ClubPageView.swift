//
//  ClubPageView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/10/23.
//

import SwiftUI

struct ClubPageView: View {
    @State var isLeader: Bool
    @State var showClubSettings: Bool = false
    
    var name: String
    var description: String
    var leaders: [String]
    var meetingBlocks: [String]
    
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @Namespace var animation
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack() {
                    Spacer()
                        .frame(height: 15)
                    
                    generalInfo
                    
                    news
                    
                    Spacer()
                        .frame(height: 95)
                }
            }
        }
        .sheet(isPresented: $showClubSettings, content: { ClubSettingsView() })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                switch isLeader {
                case true:
                    Button {
                        showClubSettings.toggle()
                    } label: {
                        NavButtonView(systemName: "gear")
                    }
                case false:
                    Text("")
                }
            })
        }
    }
}

extension ClubPageView {
    var generalInfo: some View {
        Group {
            HStack {
                Text(name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Spacer()
            }
            
            ParagraphLabel(name: description)
                .padding(.horizontal)
                .padding(.bottom, 7)
            
            HStack {
                
                Text("Leaders: \(leaders.joined(separator: ", "))")
                    .font(.headline)
                    .padding(.horizontal)
                
                Spacer()
            }
            
            HStack {
                Text("Meeting Blocks: \(meetingBlocks.joined(separator: "; "))")
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
            HeaderLabel(name: "Announcements")
                .padding(.leading, 5)
            
            ClubAnnouncementsTile(postedBy: "Daniel Shola-Philips", announcement: "Music Production Club has been officially laid to rest. Come to our memorial service this Friday at 12:00pm. RIP :(", time: Date.now)
                .padding(.horizontal)
            
            HeaderLabel(name: "Next Meeting")
                .padding(.leading, 5)
            
            HStack {
                Text(Date.now, style: .date)
                Text(Date.now, style: .time)
            }
            .fontWeight(.semibold)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .glass()
            .padding(.horizontal)
            
            HeaderLabel(name: "Upcoming Events")
                .padding(.leading, 5)
            
            SubtitleLabel(name: "There are no upcoming events.")
                .padding(.horizontal)
        }
    }
}
