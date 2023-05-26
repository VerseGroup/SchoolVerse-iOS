//
//  ClearBackgroundView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/25/23.
//

import SwiftUI

// source: https://stackoverflow.com/questions/63745084/how-can-i-make-a-background-color-with-opacity-on-a-sheet-view

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}
