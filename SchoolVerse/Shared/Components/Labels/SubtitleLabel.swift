//
//  SubtitleLabel.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/26/22.
//

import SwiftUI

struct SubtitleLabel: View {
    var name: String
    
    var body: some View {
        Text(name)
            .fontWeight(.semibold)
            .font(.headline)
            .foregroundColor(Color.white)
            .padding()
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .glass()
    }
}

struct SubtitleLabel_Previews: PreviewProvider {
    static var previews: some View {
        SubtitleLabel(name: "SchoolVerse by VerseGroup, LLC")
            .previewLayout(.sizeThatFits)
            .padding(30)
    }
}
