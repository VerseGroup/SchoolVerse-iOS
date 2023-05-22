//
//  NewFriendsView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/4/23.
//

import SwiftUI

struct PendingFriendsView: View {
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @State var text: String
    
    var requestTypes: [String] = ["New Invites", "Sent Requests"]
    @State var selectedType: String = "New Invites"
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                Spacer()
                    .frame(height: 10)
                
                HStack(spacing: 20) {
                    ForEach(requestTypes, id: \.self) { type in
                        Text(type)
                            .fontWeight(.semibold)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width / 3)
                            .background (
                                ZStack {
                                    if type == selectedType {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.clear)
                                            .padding(20)
                                            .taintedGlass()
                                            .matchedGeometryEffect(id: "currentType", in: animation)
                                    }
                                }
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedType = type
                                }
                            }
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 5)
                .cornerRadius(20)
                .heavyGlass()
                .padding(.bottom)
                
                
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
                        
                        //                        Spacer()
                        //                            .frame(height: 95)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .heavyGlass()
                }
            }
            .navigationTitle("Friend Requests")
        }
    }
}

