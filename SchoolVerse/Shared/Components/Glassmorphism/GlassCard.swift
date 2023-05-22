//
//  GlassCard.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 9/29/22.
//

import SwiftUI

struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .opacity(0.1)
                    .background(
                        Color.white
                            .opacity(0.08)
                            .blur(radius: 10)
                    )
                    // Strokes
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke (
                                .linearGradient(.init(colors: [
                                    Color("Purple"),
                                    Color("Purple").opacity(0.5),
                                    .clear,
                                    .clear,
                                    .clear,
                                    .clear,
                                    Color("OnboardingCyan").opacity(0.5),
                                    Color("OnboardingCyan")
                                ]),startPoint: .topLeading, endPoint: .bottomTrailing) ,lineWidth: 2.5
                            )
                    )
            )
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCard())
    }
}
