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
    @State var course: Course = Course(id: "other", name: "Other")
    @State var validName: Bool = false
    
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    enum Field: Hashable {
        case name
        case description
    }
    
    @FocusState private var focusedField: Field?
    
    // replaces presentationMode
    // source: https://developer.apple.com/documentation/swiftui/environmentvalues/dismiss
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack { 
            ColorfulBackgroundView()
            
            VStack(spacing: 10) {
                Spacer().frame(height: 75)
                
                Group {
                    HeaderLabel(name: "Task Details")
                        .padding(.horizontal, 5)
                    
                    CustomTextField(placeholder: "Enter a task name", text: $task.name)
                        .focused($focusedField, equals: .name)
                        .warningAccessory($task.name, valid: $validName, warning: "Invalid Name") { name in
                            isNotEmpty(text: name)
                        }
                        .padding(.horizontal)
                    
                    CustomTextField(placeholder: "Enter a task description", text: $task.description)
                        .focused($focusedField, equals: .name)
                        .padding(.horizontal)
                    
                    DatePicker(selection: $task.dueDate, displayedComponents: [.date, .hourAndMinute]) {
                        Text("Due date")
                            .padding(.leading)
                    }
                    .tint(accentColor)
                    .padding(10)
                    .glass()
                    .padding(.horizontal)
                    
                    

                }
                
                Group {
                    HeaderLabel(name: "Course Details")
                        .padding(.horizontal, 5)
                    
                    
                    Picker(selection: $course) {
                        ForEach(repo.courses, id:\.id) { course in
                            Text(course.name).tag(course)
                        }
                        Text("Other").tag(Course(id: "other", name: "Other"))
                    } label: {
                        Text("Course")
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .glass()
                    .padding()
                }
                
                Spacer()
                
                Button {
                    task.courseId = course.id
                    task.courseName = course.name
                    repo.addTask(task)
                    dismiss()
                } label: {
                    Text("Submit")
                        .foregroundColor(Color.white)
                        .padding()
                        .padding(.horizontal)
                        .glassCardFull()
                        .opacity((task.name.isEmpty) ? 0.25 : 1)
                }
                .disabled(task.name.isEmpty)
                
                Spacer()
            }
        }
        .navigationTitle("Add a Task")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button {
                    focusedField = nil
                } label: {
                    Text("Done")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .glass()
                }
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
