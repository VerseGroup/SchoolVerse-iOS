//
//  TasksView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import SwiftUI

// TODO: include ALL classes, not just classes with assignments, in the class sort view
struct TasksView: View {
    @StateObject var vm = TaskListViewModel()
    
    @State var classSort: Bool = false
    @State var showAddTaskView: Bool = false
    
    @State var revealPrevious: Bool = false
    @State var revealCurrent: Bool = true
    @State var revealFuture: Bool = true
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if classSort {
                        ForEach(vm.tasksDictionary.keys.sorted(), id:\.self) { key in
                            DisclosureGroup {
                                if (vm.tasksDictionary[key] ?? []).isEmpty {
                                    Text("No assignments soon!")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .glass()
                                } else {
                                    ForEach(vm.tasksDictionary[key] ?? []) { task in
                                        TaskTileView(vm: TaskCellViewModel(task: task))
                                            .padding(.horizontal, 5)
                                            .padding(.top, 2)
                                            .padding(.bottom, 7)
                                    }
                                }
                            } label: {
                                HeaderLabel(name: key)
                            }
                            .padding(.horizontal)
                            .padding(5)
                            .tint(Color.white)
                        }
                    } else {
                        DisclosureGroup(isExpanded: $revealPrevious) {
                            if vm.previousTasks.isEmpty {
                                Text("No assignments!")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .glass()
                            } else {
                                ForEach(vm.previousTasks) { task in
                                    TaskTileView(vm: TaskCellViewModel(task: task))
                                        .padding(.horizontal, 5)
                                        .padding(.top, 2)
                                        .padding(.bottom, 7)
                                }
                            }
                        } label: {
                            HeaderLabel(name: "Previous tasks")
                        }
                        .padding(.horizontal)
                        .padding(5)
                        .tint(Color.white)
                        
                        DisclosureGroup(isExpanded: $revealCurrent) {
                            if vm.currentTasks.isEmpty {
                                Text("No assignments soon!")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .glass()
                            } else {
                                ForEach(vm.currentTasks) { task in
                                    TaskTileView(vm: TaskCellViewModel(task: task))
                                        .padding(.horizontal, 5)
                                        .padding(.top, 2)
                                        .padding(.bottom, 7)
                                }
                            }
                        } label: {
                            HeaderLabel(name: "Current tasks")
                        }
                        .padding(.horizontal)
                        .padding(5)
                        .tint(Color.white)
                        
                        DisclosureGroup(isExpanded: $revealFuture) {
                            if vm.futureTasks.isEmpty {
                                Text("No assignments soon!")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .glass()
                            } else {
                                ForEach(vm.futureTasks) { task in
                                    TaskTileView(vm: TaskCellViewModel(task: task))
                                        .padding(.horizontal, 5)
                                        .padding(.top, 2)
                                        .padding(.bottom, 7)
                                }
                            }
                        } label: {
                            HeaderLabel(name: "Future tasks")
                        }
                        .padding(.horizontal)
                        .padding(5)
                        .tint(Color.white)
                    }
                    
                    Spacer()
                        .frame(height: 75)
                }
            }
            .overlay {
                if vm.isLoading {
                    LoadingView(text: "Scraping tasks...")
                }
            }
            .alert("Error", isPresented: $vm.hasError, actions: {
                Button("OK", role: .cancel) { }
            }) {
                Text(vm.errorMessage ?? "")
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    vm.scrape()
                } label: {
                    NavButtonView(systemName: "arrow.clockwise")
                        .opacity(vm.isAvailable ? 1 : 0.25)
                }
                .disabled(!vm.isAvailable)
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Picker(selection: $classSort, label: Text("Sorting options")) {
                        Text("Sort by class").tag(true)
                        Text("Sort by due date").tag(false)
                    }
                } label: {
                    NavButtonView(systemName: "line.3.horizontal.decrease")
                }
                
                Button {
                    showAddTaskView.toggle()
                } label: {
                    NavButtonView(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddTaskView) {
            NavigationStack {
                AddTaskView()
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
