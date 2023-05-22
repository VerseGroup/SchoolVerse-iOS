//
//  ParagraphLabel.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/26/22.
//

import SwiftUI

struct ParagraphLabel: View {
    var name: String
    
    var body: some View {
        Text(name)
            .fontWeight(.semibold)
            .foregroundColor(Color.white)
            .font(.subheadline)
            .padding()
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity)
            .glass()
    }
}

struct ParagraphLabel_Previews: PreviewProvider {
    static var previews: some View {
        ParagraphLabel(name: "SchoolVerse by VerseGroup, LLC")
            .previewLayout(.sizeThatFits)
            .padding(30)
    }
}
