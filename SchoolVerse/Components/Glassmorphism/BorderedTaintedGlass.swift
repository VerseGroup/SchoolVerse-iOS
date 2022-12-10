//
//  BorderedTaintedGlass.swift
//  SchoolVerse
//
//  Created by dshola-philips on 12/3/22.
//

import SwiftUI

struct BorderedTaintedGlass: ViewModifier {
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    
    @State private var animateGradient = false
    
    @State var start = UnitPoint.topLeading
    @State var end = UnitPoint.bottomTrailing

    let timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect()
    
    let colors: [Color] = [
        //Color("Purple"),
        //Color("Purple").opacity(0.5),
        //Color("OnboardingCyan").opacity(0.5),
        //Color("OnboardingCyan")
        Color.white,
        Color.clear,
        Color.clear,
        Color.clear,
        Color.clear,
        Color.clear,
        Color.clear,
        Color.clear,
        Color.clear,
        Color.clear,
        Color.clear
    ]
        
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke (
                                LinearGradient(
                                    gradient: Gradient(colors: colors),
                                    startPoint: start,
                                    endPoint: end
                                )
                                
                                , lineWidth: 3
                            )
                            .animation(Animation.easeInOut.repeatForever(), value: start)
                            .onReceive(timer) { _ in
                                self.start = nextPointFrom(self.start)
                                self.end = nextPointFrom(self.end)
                            }
                    )
            )
    }
    
    func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
        switch currentPoint {
        case .top:
            return .topLeading
        case .topLeading:
            return .leading
        case .leading:
            return .bottomLeading
        case .bottomLeading:
            return .bottom
        case .bottom:
            return .bottomTrailing
        case .bottomTrailing:
            return .trailing
        case .trailing:
            return .topTrailing
        case .topTrailing:
            return .top
        default:
            print("Unknown point")
            return .top
        }
    }
}

extension View {
    func borderedTaintedGlass() -> some View {
        modifier(BorderedTaintedGlass())
    }
}
