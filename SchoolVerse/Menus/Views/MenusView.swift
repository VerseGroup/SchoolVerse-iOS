//
//  MenusView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct MenusView: View {
    @StateObject var menuListVM = MenusListViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(menuListVM.menus) { menu in
                    MenuCellView(menu: menu)
                        .listRowBackground(EmptyView())
                        .listRowSeparator(.hidden)
                }
            }
        }
        .navigationTitle("Menus")
    }
}

struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenusView()
    }
}
