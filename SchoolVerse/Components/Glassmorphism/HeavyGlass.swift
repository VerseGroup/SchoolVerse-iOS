//
//  HeavyGlass.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 9/30/22.
//

import SwiftUI

struct HeavyGlass: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black)
                    .opacity(0.3)
                    .background(
                        Color.black
                            .opacity(0.05)
                            .blur(radius: 10)
                    )
            )
    }
}

extension View {
    func heavyGlass() -> some View {
        modifier(HeavyGlass())
    }
}
