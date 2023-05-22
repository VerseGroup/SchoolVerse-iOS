//
//  iPadColorfulBackgroundView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 5/22/23.
//

import SwiftUI

struct iPadColorfulBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("BG1"), Color("BG2")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                let size = proxy.size
                
                Color.black
                    .opacity(0.7)
                    .blur(radius: 170)
                    .ignoresSafeArea()
                
                Circle()
                    .fill(Color.accent.purple)
                    .padding(50)
                    .blur(radius: 100)
                    .offset(x: -size.width / 1.8, y: size.height / 15)
                
                Circle()
                    .fill(Color.accent.pink)
                    .padding(225)
                    .blur(radius: 120)
                    .offset(x: size.width / 2.2, y: -size.height / 6.5)
                
                Circle()
                    .fill(Color.accent.blue)
                    .padding(75)
                    .blur(radius: 120)
                    .offset(x: size.width / 1.8, y: size.height / 1.5)
                
                Circle()
                    .fill(Color.accent.cyan)
                    .padding(50)
                    .blur(radius: 120)
                    .offset(x: -size.width / 1.5, y: size.height / 2)
                
            }
        }
    }
}

