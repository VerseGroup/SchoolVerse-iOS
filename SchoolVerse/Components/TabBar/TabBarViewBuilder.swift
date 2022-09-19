//
//  TabBarViewBuilder.swift
//  SchoolVerseTesting
//
//  Created by Steven Yu on 5/23/22.
//

// TODO: Fix bug  for .vStack Display Style causing the tab bar bug

import SwiftUI

/// Custom tab bar with lazy loading.
///
/// Tabs are loaded lazily, as they are selected. Each tab's .onAppear will only be called on first appearance. Set DisplayStyle to .vStack to position TabBar vertically below the Content. Use .zStack to put the TabBar in front of the Content .
struct TabBarViewBuilder<Content:View, TabBar: View>: View {
    
    public enum DisplayStyle {
        case vStack
        case zStack
    }

    let style: DisplayStyle
    let content: Content
    let tabBar: TabBar
    
    public init(
        style: DisplayStyle = .zStack,
        @ViewBuilder content: () -> Content,
        @ViewBuilder tabBar: () -> TabBar) {
        self.style = style
        self.content = content()
        self.tabBar = tabBar()
    }
        
    public var body: some View {
        layout
    }
    
    @ViewBuilder var layout: some View {
        switch style {
        case .vStack:
            VStack(spacing: 0) {
                ZStack {
                    content
                }
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                tabBar
                    .foregroundColor(Color.app.screen)
            }
        case .zStack:
            ZStack(alignment: .bottom) {
                content
                tabBar
            }
        }
    }
}
