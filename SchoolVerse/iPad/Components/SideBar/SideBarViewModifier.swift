//
//  SideBarViewModifier.swift
//  SchoolVerse
//
//  Created by dshola-philips on 5/21/23.
//

import Foundation
import SwiftUI

struct SideBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [SideBarItem] = []
    
    static func reduce(value: inout [SideBarItem], nextValue: () -> [SideBarItem]) {
        value += nextValue()
    }
}

struct SideBarItemViewModifer: ViewModifier {
    
    @State private var didLoad: Bool = false
    let tab: SideBarItem
    let selection: SideBarItem
    
    func body(content: Content) -> some View {
        ZStack {
            if didLoad || selection == tab {
                content
                    .preference(key: SideBarItemsPreferenceKey.self, value: [tab])
                    .opacity(selection == tab ? 1 : 0)
                    .onAppear {
                        didLoad = true
                    }
            }
        }
    }

}

extension View {
    func sideBarItem(tab: SideBarItem, selection: SideBarItem) -> some View {
        modifier(SideBarItemViewModifer(tab: tab, selection: selection))
    }
}
