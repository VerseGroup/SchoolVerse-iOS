//
//  TasksView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import SwiftUI

struct TasksView: View {
    @StateObject var vm = TaskListViewModel()
    
    var body: some View {
        ZStack {
            Color.app.screen
                .ignoresSafeArea()
            
            List {
                Button {
                    vm.scrape()
                } label: {
                    Text("Ssrape")
                }
                ForEach(vm.taskCellViewModels) { taskCellVM in
                    TaskTileView(vm: taskCellVM)
                }
                
            }
            .overlay {
                if vm.isLoading {
                    ProgressView("Scraping tasks...")
                }
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
