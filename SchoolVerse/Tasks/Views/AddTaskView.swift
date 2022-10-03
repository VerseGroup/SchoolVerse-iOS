//
//  AddTaskView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/2/22.
//

import SwiftUI
import Resolver

struct AddTaskView: View {
    @ObservedObject private var repo: TaskRepository = Resolver.resolve()
    @State var task: SchoolTask = SchoolTask(id: nil, name: "", completed: false, dueDate: Date.now, description: "", courseId: "", courseName: "", platformInformation: PlatformInformation(assignmentCode: UUID().uuidString, platformCode: "sv"))
    @State var course: Course = Course(id: "custom", name: "Custom", section: "custom")
    @State var validName: Bool = false
    
    // replaces presentationMode
    // source: https://developer.apple.com/documentation/swiftui/environmentvalues/dismiss
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section(header: Text("Task Details")) {
                TextField("Enter a task name", text: $task.name)
                    .warningAccessory($task.name, valid: $validName, warning: "Invalid Name") { name in
                        isNotEmpty(text: name)
                    }
                TextField("Enter a task description", text: $task.description)
                DatePicker("Due Date", selection: $task.dueDate, displayedComponents: [.date, .hourAndMinute])
                Toggle(isOn: $task.completed) {
                    Text("Finished")
                }
            }
            
            // change to a picker that chooses from user's array
            Section(header: Text("Course Details")) {
                Picker(selection: $course) {
                    ForEach(repo.courses, id:\.id) { course in
                        Text(course.name).tag(course)
                    }
                    Text("Custom").tag(Course(id: "custom", name: "Custom", section: "custom"))
                } label: {
                    Text("Course")
                }
                .pickerStyle(.menu)
            }
            
            // change to viewmodifier later
            // source: https://stackoverflow.com/questions/56692933/swiftui-centre-content-on-a-list
            Section() {
                Button() {
                    task.courseId = course.id
                    task.courseName = course.name
                    repo.addTask(task)
                    dismiss()
                } label: {
                    Text("Add Task")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .disabled(!validName)
                .tint(.purple) // change to custom color scheme later
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                
            }                        .listRowBackground(EmptyView())
            
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Add a Task")
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
