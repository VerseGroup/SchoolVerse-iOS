//
//  TasksView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import SwiftUI

struct TasksView: View {
    @StateObject var vm = TaskListViewModel()
    
//    @State var previousTasks: [Task]
    
    var body: some View {
        ZStack {
            Color.app.screen
                .ignoresSafeArea()
            
            List {
                Button {
                    vm.scrape()
                } label: {
                    Text("Scrape")
                }
                
                DisclosureGroup {
                    ForEach(vm.previousTaskCellViewModels) { taskCellVM in
                        TaskTileView(vm: taskCellVM)
                    }
                } label: {
                    Text("Previous tasks")
                }
                
                DisclosureGroup {
                    ForEach(vm.currentTaskCellViewModels) { taskCellVM in
                        TaskTileView(vm: taskCellVM)
                    }
                } label: {
                    Text("Current tasks")
                }
                
                DisclosureGroup {
                    ForEach(vm.futureTaskCellViewModels) { taskCellVM in
                        TaskTileView(vm: taskCellVM)
                    }
                } label: {
                    Text("Future tasks")
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