//
//  NavButtonView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/8/22.
//

import SwiftUI

struct NavButtonView: View {
    var systemName: String

    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(.white)
            .font(.system(size:20))
            .frame(width: 25, height: 25)
            .padding(5)
    }
}
