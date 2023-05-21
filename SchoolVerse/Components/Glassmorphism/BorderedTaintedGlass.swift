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
//                            .trim(from: animate ? 0: 1, to: animate ? 0.5: 1)
//                            .stroke (
//                                .linearGradient(.init(colors: [
//                                    Color("Purple"),
//                                    Color("Purple").opacity(0.5),
//                                    Color("OnboardingCyan").opacity(0.5),
//                                    Color("OnboardingCyan")
//                                ]),startPoint: .topLeading, endPoint: .bottomTrailing) ,lineWidth: 2.5
//                            )
                            .stroke(accentColor, lineWidth: 5)
                            .opacity(animate ? 1: 0.25)
                            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false).delay(0.5), value: animate)
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
