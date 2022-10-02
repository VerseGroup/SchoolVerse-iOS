//
//  SportsView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

struct SportsView: View {
    @StateObject var vm: SportsListViewModel = SportsListViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(vm.sports) { sports in
                    SportsCellView(sports: sports)
                        .listRowBackground(EmptyView())
                        .listRowSeparator(.hidden)
                }
            }
        }
        .navigationTitle("Sports")
    }
}

struct SportsView_Previews: PreviewProvider {
    static var previews: some View {
        SportsView()
    }
}
