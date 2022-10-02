//
//  TasksView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import SwiftUI

struct TasksView: View {
    @StateObject var vm = TaskListViewModel()
    
    @State var classSort: Bool = true
    
    var body: some View {
        ZStack {
            Color.app.screen
                .ignoresSafeArea()
            
            List {
                if classSort {
                    ForEach(vm.tasksDictionary.keys.sorted(), id:\.self) { key in
                        DisclosureGroup {
                            ForEach(vm.tasksDictionary[key] ?? []) { task in
                                TaskTileView(vm: TaskCellViewModel(task: task))
                            }
                        } label: {
                            Text(key)
                        }
                    }
                } else {
                    DisclosureGroup {
                        ForEach(vm.previousTasks) { task in
                            TaskTileView(vm: TaskCellViewModel(task: task))
                        }
                    } label: {
                        Text("Previous tasks")
                    }
                    
                    DisclosureGroup {
                        ForEach(vm.currentTasks) { task in
                            TaskTileView(vm: TaskCellViewModel(task: task))
                        }
                    } label: {
                        Text("Current tasks")
                    }
                    
                    DisclosureGroup {
                        ForEach(vm.futureTasks) { task in
                            TaskTileView(vm: TaskCellViewModel(task: task))
                        }
                    } label: {
                        Text("Future tasks")
                    }
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
                Picker(selection: $classSort) {
                    Text("Sort by class").tag(true)
                    Text("Sort by due date").tag(false)
                } label: {
                    Label("Sorting", systemImage: "line.3.horizontal.decrease.circle")
                }
                
                Spacer()
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
