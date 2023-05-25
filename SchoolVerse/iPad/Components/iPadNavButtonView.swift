//
//  iPadNavButtonView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/25/23.
//

import SwiftUI

struct iPadNavButtonView: View {
    var systemName: String

    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(.white)
            .font(.system(size:25))
            .frame(width: 35, height: 35)
            .padding(5)
            .padding(.top, 20)
    }
}
