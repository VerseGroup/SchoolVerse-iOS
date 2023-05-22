//
//  SideBarView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 5/21/23.
//

import SwiftUI

struct SideBarView: View {
    let tabs: [SideBarItem]
    
    @Binding var selection: SideBarItem
    @State var localSelection: SideBarItem
    
    @Namespace private var namespace
    
    var body: some View {
        sideBar
            .onChange(of: selection, perform: { value in
                withAnimation(.easeInOut) {
                    localSelection = value
                }
            })
    }
}

extension SideBarView {
    private func tabView(tab: SideBarItem) -> some View {
        SideBarButton(sideBarItem: tab)
            .background(
                ZStack {
                    if localSelection == tab {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.clear)
                            .taintedGlass()
                            .matchedGeometryEffect(id: "background_selection", in: namespace)
                            .frame(width:240, height: 60)
                    }
                }
                    
            )
        
    }
    
    private var sideBar: some View {
        VStack (alignment: .leading, spacing: 20) {
            Spacer()
                .frame(height: 2)
            
            ForEach(0..<6, id: \.self) { i in
                tabView(tab: tabs[i])
                    .onTapGesture {
                        switchToTab(tab: tabs[i])
                    }
            }
            
            Spacer()
            
            ForEach(6..<8, id: \.self) { i in
                tabView(tab: tabs[i])
                    .onTapGesture {
                        switchToTab(tab: tabs[i])
                    }
            }
            
            Spacer()
                .frame(height: 2)
        }
        .frame(width: 265)
        .heavyGlass()
        .padding()
    }
    
    private func switchToTab(tab: SideBarItem) {
        selection = tab
    }
}
