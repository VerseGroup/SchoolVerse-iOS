//
//  DestructiveButtonLabel.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/26/22.
//

import SwiftUI

struct DestructiveButtonLabel: View {
    var name: String
    
    var body: some View {
        Text(name)
            .fontWeight(.bold)
            .font(.headline)
            .foregroundColor(Color.red)
            .padding()
            .frame(maxWidth: .infinity)
            .glass()
    }
}

struct DestructiveButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        DestructiveButtonLabel(name: "SchoolVerse by VerseGroup, LLC")
            .previewLayout(.sizeThatFits)
            .padding(30)
    }
}
