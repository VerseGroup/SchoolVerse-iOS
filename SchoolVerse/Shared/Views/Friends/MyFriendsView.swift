//
//  NewFriendsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/4/23.
//

import SwiftUI

struct MyFriendsView: View {
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @State var text: String
    @State var starred: Bool
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                Spacer()
                    .frame(height: 10)
                
                HStack{
                    SearchBarView(searchText: $text)
                    
                    Button(action: {
                        
                    }, label: {
                        NavButtonView(systemName: "line.3.horizontal.decrease")
                    })
                    
                    Button(action: {
                        starred.toggle()
                    }, label: {
                        if starred {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size:20))
                                .frame(width: 25, height: 25)
                                .padding(5)
                                .padding(.trailing, 10)
                        } else {
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                                .font(.system(size:20))
                                .frame(width: 25, height: 25)
                                .padding(5)
                                .padding(.trailing, 10)
                        }
                    })
                }
                .padding(.leading, 10)
                
                Spacer()
                    .frame(height: 15)
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        Spacer()
                            .frame(height: 20)
                        
                        Text("You Have NO FRIENDS!!!")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        //                        Spacer()
                        //                            .frame(height: 95)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .heavyGlass()
                }
            }
            .navigationTitle("My Friends")
        }
    }
}

