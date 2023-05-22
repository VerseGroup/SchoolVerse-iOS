//
//  SideBarButton.swift
//  SchoolVerse
//
//  Created by dshola-philips on 5/21/23.
//

import SwiftUI

struct SideBarButton: View {
    var sideBarItem: SideBarItem
    
    var body: some View {
        HStack {
            Image(systemName: sideBarItem.iconName)
                .frame(width: 50)
            
            Text(sideBarItem.title)
            
            Spacer()
        }
        .fontWeight(.medium)
        .font(.system(size: 28))
        .padding(10)
        .padding(.horizontal)
        .frame(maxWidth: 240)
    }
}
