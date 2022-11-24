//
//  TasksByUrgencyView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 11/24/22.
//

import SwiftUI

struct TasksByUrgencyView: View {
    @StateObject var vm = TaskListViewModel()
    
    @State var revealPrevious: Bool = false
    @State var revealCurrent: Bool = true
    @State var revealFuture: Bool = true
    
    var body: some View{
        DisclosureGroup(isExpanded: $revealPrevious) {
            if vm.previousTasks.isEmpty {
                Text("No assignments!")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(15)
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
                    .padding(15)
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
                    .padding(15)
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
}
