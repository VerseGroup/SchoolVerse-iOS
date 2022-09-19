//
//  Color.swift
//  SchoolVerse
//
//  Created by Daniel Shola-Philips on 8/25/22.
//

import Foundation
import SwiftUI

extension Color {
    static let app = AppTheme()
    static let accent = AccentColors()
    static let classColor = ClassColors()
}


struct AppTheme {
    let screen = Color("Screen Color")
    let text = Color("Text Color")
    let secondary = Color("Secondary App Color")
}

struct AccentColors {
    let blue = Color("Blue")
    let cyan = Color("Cyan")
    let pink = Color("Pink")
    let purple = Color("Purple")
}

struct ClassColors {
    let blue = Color("Blue Class")
    let green = Color("Green Class")
    let lightBlue = Color("Light Blue Class")
    let lime = Color("Lime Class")
    let magenta = Color("Magenta Class")
    let none = Color("None Class")
    let orange = Color("Orange Class")
    let pink = Color("Pink Class")
    let purple = Color("Purple Class")
    let red = Color("Red Class")
    let yellow = Color("Yellow Class")
}
