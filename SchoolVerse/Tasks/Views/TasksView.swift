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
            .if(vm.isAvailable) { view in
                view.refreshable {
                    vm.scrape()
                }
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    vm.scrape()
                } label: {
                    Label("Scrape", systemImage: "arrow.clockwise")
                }
                .disabled(!vm.isAvailable)
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
