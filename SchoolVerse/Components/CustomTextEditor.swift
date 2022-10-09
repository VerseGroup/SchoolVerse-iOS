//
//  CustomTextEditorView.swift
//  SchoolVerseRedesignTesting
//
//  Created by Hackley on 10/6/22.
//

import SwiftUI

struct CustomTextEditor: View {
    @Binding var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .scrollContentBackground(.hidden)
            .lineLimit(1...)
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
