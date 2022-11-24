//
//  TasksByClassView.swift
//  SchoolVerse
//
//  Created by dshola-philips on 11/24/22.
//

import SwiftUI

struct TasksByClassView: View {
    @StateObject var vm = TaskListViewModel()
    
    var body: some View {
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
    }
}
