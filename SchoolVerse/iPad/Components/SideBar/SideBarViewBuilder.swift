//
//  SideBarViewBuilder.swift
//  SchoolVerse
//
//  Created by dshola-philips on 5/21/23.
//

import Foundation
import SwiftUI

struct SideBarViewBuilder<Content:View, SideBar: View>: View {
    let content: Content
    let tabBar: SideBar
    
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder sideBar: () -> SideBar) {
        self.content = content()
        self.tabBar = sideBar()
    }
    
    public var body: some View {
        layout
    }
    
    @ViewBuilder var layout: some View {
        HStack(alignment: .top) {
            tabBar
            
            ZStack {
                content
                    .padding(.trailing, 15)

            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
    }
}
