//
//  NavButtonView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/8/22.
//

import SwiftUI

struct NavButtonView: View {
    var systemName: String
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan

    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(accentColor)
            .font(.system(size:20))
            .frame(width: 28, height: 28)
            .padding(10)
            .heavyGlass()
    }
}
