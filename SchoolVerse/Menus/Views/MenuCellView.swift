//
//  MenuCellView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct MenuCellView: View {
    let menu: SchoolMenu
    @State var showMenuDetailView: Bool = false
    
    var body: some View {
        HStack {
            Text(menu.date.weekDateString())
                .font(.title3)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .background(Color.purple)
        .cornerRadius(10)
        .sheet(isPresented: $showMenuDetailView) {
            MenuDetailView(menu: menu)
        }
        .onTapGesture {
            showMenuDetailView.toggle()
        }
    }
}

struct MenuCellView_Previews: PreviewProvider {
    static var previews: some View {
        MenuCellView(menu: SchoolMenu(id: nil, date: Date.now, breakfast: [], lunch: [], dinner: []))
    }
}
