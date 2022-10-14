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
            .font(.system(size:15))
            .frame(width: 25, height: 25)
            .padding(10)
            .heavyGlass()
    }
}
