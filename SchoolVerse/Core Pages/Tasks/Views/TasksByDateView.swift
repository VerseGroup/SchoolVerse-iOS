//
//  TasksByDateView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 11/24/22.
//

import SwiftUI

struct TasksByDateView: View {
    @EnvironmentObject var vm: TaskListViewModel
    
    var body: some View {
        if !vm.tasksClassDictionary.isEmpty {
            ForEach(vm.tasksDateDictionary.keys.sorted(), id:\.self) { key in

                VStack {
                    HeaderLabel(name: key.weekDateString())
                    
                    if (vm.tasksDateDictionary[key] ?? []).isEmpty {
                        Text("No assignments soon!")
                            .font(.headline)
                            .fontWeight(.bold)
                            .glass()
                    } else {
                        ForEach(vm.tasksDateDictionary[key] ?? []) { task in
                            TaskTileView(vm: TaskCellViewModel(task: task))
                                .padding(.horizontal, 5)
                                .padding(.top, 2)
                                .padding(.bottom, 7)
                        }
                    }
                    
                }
                .padding(.horizontal)
                .padding(5)
                .tint(Color.white)
            }
        } else {
            VStack {
                Spacer()
                Text("No Tasks Yet!")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                Text("Refresh tasks with the upper left button.")
                Spacer()
                Spacer()
            }
            .transition(.opacity)
        }
    }
}
