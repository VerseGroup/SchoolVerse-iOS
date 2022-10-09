//
//  CustomTextFieldView.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 10/6/22.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .frame(minWidth: 350)
            )
            .padding(.horizontal, 10)
            .glass()
    }
}
