//
//  TitleLabel.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/25/22.
//

import SwiftUI

struct TitleLabel: View {
    var name: String
    
    var body: some View {
        Text(name)
            .fontWeight(.bold)
            .font(.headline)
            .foregroundColor(Color.white)
            .padding()
            .frame(maxWidth: .infinity)
            .glass()
    }
}

struct TitleLabel_Previews: PreviewProvider {
    static var previews: some View {
        TitleLabel(name: "SchoolVerse by VerseGroup, LLC")
            .previewLayout(.sizeThatFits)
            .padding(30)
    }
}
