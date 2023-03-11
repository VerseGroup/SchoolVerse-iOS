//
//  MoreView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/9/22.
//

import SwiftUI

struct MoreView: View {
    
    @Binding var selection: TabBarItem
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
                // ipad
                if(UIDevice.current.userInterfaceIdiom == .pad) {
                    
                    Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                        GridRow {
                            NavigationLink {
                                SettingsView()
                            } label: {
                                MoreInfoCardView(imageName: "gear", name: "Settings")
                            }
                            
                            NavigationLink {
                                AboutView()
                            } label: {
                                MoreInfoCardView(imageName: "info.circle.fill", name: "About")
                            }
                            
                            NavigationLink {
                                SportsView()
                            } label: {
                                MoreInfoCardView(imageName: "sportscourt", name: "Sports")
                            }
                            
                            NavigationLink {
                                EventsView()
                            } label: {
                                MoreInfoCardView(imageName: "calendar.badge.exclamationmark", name: "Events")
                            }
                        }
                        
                        GridRow {
                            Button {
                                selection = .menu
                            } label: {
                                MoreInfoCardView(imageName: "menucard.fill", name: "Menu")
                            }
                            
                            Button {
                                selection = .tasks
                            } label: {
                                MoreInfoCardView(imageName: "list.bullet.rectangle.portrait", name: "Tasks")
                            }
                            
                            //                        Button {
                            //                            selection = .clubs
                            //                        } label: {
                            //                            MoreInfoCardView(imageName: "person.2.fill", name: "Clubs")
                            //                        }
                            
                            Button {
                                selection = .schedule
                            } label: {
                                MoreInfoCardView(imageName: "calendar", name: "Schedule")
                            }
                        }
                    }
                    .padding(15)
                    
                // iphone
                } else {
                    Grid(horizontalSpacing: 20, verticalSpacing: 20) {
                        GridRow {
                            NavigationLink {
                                SettingsView()
                            } label: {
                                MoreInfoCardView(imageName: "gear", name: "Settings")
                            }
                            
                            NavigationLink {
                                AboutView()
                            } label: {
                                MoreInfoCardView(imageName: "info.circle.fill", name: "About")
                            }
                        }
                        
                        GridRow {
                            NavigationLink {
                                SportsView()
                            } label: {
                                MoreInfoCardView(imageName: "sportscourt", name: "Sports")
                            }
                            
                            NavigationLink {
                                EventsView()
                            } label: {
                                MoreInfoCardView(imageName: "calendar.badge.exclamationmark", name: "Events")
                            }
                        }
                        
                        GridRow {
                            NavigationLink {
                                FriendsView()
                            } label: {
                                MoreInfoCardView(imageName: "person.2.fill", name: "Friends")
                            }
                            
                            Button {
                                selection = .menu
                            } label: {
                                MoreInfoCardView(imageName: "menucard.fill", name: "Menu")
                            }
                            
                            
                        }
                        
                        GridRow {
                            //                        Button {
                            //                            selection = .clubs
                            //                        } label: {
                            //                            MoreInfoCardView(imageName: "person.2.fill", name: "Clubs")
                            //                        }
                            Button {
                                selection = .tasks
                            } label: {
                                MoreInfoCardView(imageName: "list.bullet.rectangle.portrait", name: "Tasks")
                            }
                            
                            Button {
                                selection = .schedule
                            } label: {
                                MoreInfoCardView(imageName: "calendar", name: "Schedule")
                            }
                        }
                    } //: Grid
                    .padding(15)
                }
                
                
                Spacer()
                    .frame(height: 90)
            } //: Scroll View
            .navigationTitle("More")
            .toolbarColorScheme(.dark, for: .navigationBar)
            //.toolbarBackground(.visible, for: .navigationBar)
        } //: ZStack
    } //: body
} //: More View
