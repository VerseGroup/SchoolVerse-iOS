//
//  TextFieldWithTitle.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 8/26/22.
//

import SwiftUI

struct TextWithTitle: View {
    var placeholder: String
    var text: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(placeholder)
                    .lineLimit(1)
                    .foregroundColor(Color.white)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.bottom, 7)
            
            HStack {
                Text(text)
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer()
            }
            .foregroundColor(Color.white)
            .padding()
            .glass()
        }
    }
}
