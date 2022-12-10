//
//  Glass.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 9/30/22.
//

import SwiftUI

enum GlassType {
    case glass
    case glassCard
    case glassCardFull
    case darkGlass
    case stainedGlass
    case borderedStainedGlass
    case frostedGlass
}

struct Glass: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .opacity(0.1)
                    .background(
                        Color.white
                            .opacity(0.005)
                            .blur(radius: 10)
                    )
            )
    }
}

extension View {
    func glass() -> some View {
        modifier(Glass())
    }
}
