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
            ColorfulBackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    switch taskSort {
                    case .sortClass:
                        TasksByClassView()
                    case .sortUrgency:
                        TasksByUrgencyView()
                    case .sortDate:
                        TasksByDateView()
                    }
                    
                    Spacer()
                        .frame(height: 75)
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

