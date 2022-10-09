//
//  TaskDetailView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/2/22.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var vm: TaskCellViewModel
    @State var task: SchoolTask

    @State var validName: Bool = false
    
    @Environment(\.dismiss) var dismiss

    init(vm: TaskCellViewModel) {
        self.vm = vm
        self._task = State(initialValue: vm.task)
    }
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack(spacing: 10) {
                Spacer().frame(height: 65)
                
                CustomTextField(placeholder: "Enter a task name", text: $task.name)
                    .warningAccessory($vm.task.name, valid: $validName, warning: "Invalid Name") { name in
                        isNotEmpty(text: name)
                    }
                    .padding(.horizontal)
                
                CustomTextEditor(text: $task.description)
                    .padding(.horizontal)
                
                DatePicker(selection: $task.dueDate, displayedComponents: [.date, .hourAndMinute]) {
                    Text("Due date")
                        .padding(.leading)
                }
                .padding(10)
                .glass()
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    vm.removeTask()
                } label: {
                    NavButtonView(systemName: "trash")
                }
                
                Button {
                    vm.updateTask(task)
                    dismiss()
                } label: {
                    NavButtonView(systemName: "externaldrive.badge.checkmark")
                        .opacity((task.name == vm.task.name && task.description == vm.task.description && task.dueDate == vm.task.dueDate) ? 0.25 : 1)
                }
                .disabled(task.name == vm.task.name && task.description == vm.task.description && task.dueDate == vm.task.dueDate)
            }
        }
    }
}
