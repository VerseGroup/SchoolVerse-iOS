//
//  LargeButtonLabel.swift
//  SchoolVerse
//
//  Created by dshola-philips on 11/24/22.
//

import SwiftUI

struct LargeButtonLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .glassCardFull()
            .padding(.horizontal, 45)
    }
}

extension View {
    func largeButton() -> some View {
        modifier(LargeButtonLabel())
    }
}
