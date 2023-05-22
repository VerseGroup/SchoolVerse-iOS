//
//  TaintedGlass.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 10/2/22.
//

import SwiftUI

struct TaintedGlass: ViewModifier {
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(accentColor)
                    .opacity(0.3)
                    .background(
                        accentColor
                            .opacity(0.005)
                            .blur(radius: 10)
                    )
            )
    }
}

extension View {
    func taintedGlass() -> some View {
        modifier(TaintedGlass())
    }
}
