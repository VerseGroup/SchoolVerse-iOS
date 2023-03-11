//
//  SearchBarView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 3/4/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? Color.secondary : Color.white
                )
                .padding(.leading)
            
            TextField("Search by name...", text: $searchText)
                .foregroundColor(Color.white)
                .disableAutocorrection(true)
            
            
            Image(systemName: "xmark")
                .padding(15)
                .padding(.leading)
                .foregroundColor(Color.white)
                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    searchText = ""
                }
                    
        } //: HStack
        .font(.headline)
        .glass()
    }
}
