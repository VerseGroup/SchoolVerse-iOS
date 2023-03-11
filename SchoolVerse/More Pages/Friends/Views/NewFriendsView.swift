//
//  NewFriendsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/4/23.
//

import SwiftUI

struct NewFriendsView: View {
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @State var text: String
    
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
                            .padding(.trailing, 10)
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
                    }
                    .frame(maxWidth: .infinity)
                    .heavyGlass()
                }
            }
            .navigationTitle("Discover Friends")
        }
    }
}

