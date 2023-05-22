//
//  LoadingView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/8/22.
//

import SwiftUI

// TODO: fix frosted glass

struct LoadingView: View {
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    var text: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .blur(radius: 50)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                ProgressView()
                    .scaleEffect(1.5)
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.headline)
            }
            .foregroundColor(.white)
            .tint(.white)
            .frame(width: 200, height: 150)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 25, style: .continuous)
            )
        }
    }
}
