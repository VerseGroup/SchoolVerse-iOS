//
//  NavigationLinkLabel.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/26/22.
//

import SwiftUI

struct NavigationLinkLabel: View {
    var name: String
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.bold)
                .font(.title2)
                .padding()
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.headline)
                .padding()
        }
        .foregroundColor(Color.white)
        .glass()
    }
}
