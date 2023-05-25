//
//  TasksView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/25/22.
//

import SwiftUI

// TODO: include ALL classes, not just classes with assignments, in the class sort view
enum TaskSort: String, Codable, CaseIterable {
    case sortClass, sortUrgency, sortDate
}

struct TasksView: View {
    @StateObject var vm = TaskListViewModel()
    
    @AppStorage("task_sort") var taskSort: TaskSort = .sortUrgency
    @State var showAddTaskView: Bool = false
    
    var body: some View {
        ZStack {
            // if iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad){
                ColorfulBackgroundView()
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    if (UIDevice.current.userInterfaceIdiom == .pad) {
                        iPadNavButtons
                    }
                    
                    switch taskSort {
                    case .sortClass:
                        TasksByClassView()
                    case .sortUrgency:
                        TasksByUrgencyView()
                    case .sortDate:
                        TasksByDateView()
                    }
                    
                    // if iphone
                    if !(UIDevice.current.userInterfaceIdiom == .pad){
                        Spacer()
                            .frame(height: 75)
                    }
                }
            }
            .overlay {
                if vm.isLoading {
                    LoadingView(text: "Getting tasks...")
                }
            }
            .alert("Error", isPresented: $vm.hasError, actions: {
                Button("OK", role: .cancel) { }
            }) {
                Text(vm.errorMessage ?? "")
            }
        }
        .if(!(UIDevice.current.userInterfaceIdiom == .pad)) { view in
            view
                .navigationTitle("Tasks")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            vm.getData()
                        } label: {
                            NavButtonView(systemName: "arrow.clockwise")
                                .opacity(vm.isAvailable ? 1 : 0.25)
                        }
                        .disabled(!vm.isAvailable)
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Menu {
                            Picker(selection: $taskSort, label: Text("Sorting options")) {
                                Text("Sort by class").tag(TaskSort.sortClass as TaskSort) // just to make sure
                                Text("Sort by urgency").tag(TaskSort.sortUrgency as TaskSort) // just to make sure
                                Text("Sort by due date").tag(TaskSort.sortDate as TaskSort) // just to make sure
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
        }
        .sheet(isPresented: $showAddTaskView) {
            NavigationStack {
                AddTaskView()
            }
        }
        .environmentObject(vm)
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}

extension TasksView {
    var iPadNavButtons: some View {
        HStack {
            Button {
                vm.getData()
            } label: {
                iPadNavButtonView(systemName: "arrow.clockwise")
                    .opacity(vm.isAvailable ? 1 : 0.25)
            }
            .disabled(!vm.isAvailable)
            
            Spacer()
            
            Menu {
                Picker(selection: $taskSort, label: Text("Sorting options")) {
                    Text("Sort by class").tag(TaskSort.sortClass as TaskSort) // just to make sure
                    Text("Sort by urgency").tag(TaskSort.sortUrgency as TaskSort) // just to make sure
                    Text("Sort by due date").tag(TaskSort.sortDate as TaskSort) // just to make sure
                }
            } label: {
                iPadNavButtonView(systemName: "line.3.horizontal.decrease")
            }
            
            Button {
                showAddTaskView.toggle()
            } label: {
                iPadNavButtonView(systemName: "plus")
            }
            .padding(.trailing, 5)
            
        }
    }
}
