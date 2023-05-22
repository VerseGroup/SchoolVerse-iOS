//
//  Glass.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 9/30/22.
//

import SwiftUI

// TODO: fix frosted glass

struct FrostedGlass: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .opacity(0.9)
                    .background(
                        Color.white
                            .opacity(0.7)
                    )
            )
            .blur(radius: 20)
    }
}

extension View {
    func frostedGlass() -> some View {
        modifier(Glass())
    }
}
