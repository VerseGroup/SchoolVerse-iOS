//
//  AnyTransition+Backslide.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/9/22.
//

import SwiftUI

// source: https://stackoverflow.com/questions/69663197/how-can-i-reverse-the-slide-transition-for-a-swiftui-animation
extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
