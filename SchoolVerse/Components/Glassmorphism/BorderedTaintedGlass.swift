//
//  BorderedTaintedGlass.swift
//  SchoolVerse
//
//  Created by dshola-philips on 12/11/22.
//

import SwiftUI

struct BorderedTaintedGlass: ViewModifier {
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @State var animate: Bool = false
    
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
                    // Strokes
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .trim(from: animate ? 0: 1, to: animate ? 1: 0)
                            .stroke(.white, lineWidth: 3)
                            .animation(Animation.easeInOut(duration: 2.5).repeatForever(autoreverses: false))
                            .onAppear() {
                                self.animate.toggle()
                            }
                    )
            )
    }
}

extension View {
    func borderedtaintedGlass() -> some View {
        modifier(BorderedTaintedGlass())
    }
}
