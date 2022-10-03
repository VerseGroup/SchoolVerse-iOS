//
//  TaskTileView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/26/22.
//

import SwiftUI

struct TaskTileView: View {
    @ObservedObject var vm: TaskCellViewModel
    @State var showTaskDetailView: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: vm.task.completed ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    withAnimation(.easeIn) {
                        self.vm.task.completed.toggle()
                    }
                }
            
            VStack(alignment: .leading) {
                Text(vm.task.name)
                    .font(.headline)
                
                Text(vm.task.description)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Text(vm.task.dueDate.weekDateTimeString())
            }
            .onTapGesture {
                showTaskDetailView.toggle()
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .background(Color.purple)
        .cornerRadius(10)
        .sheet(isPresented: $showTaskDetailView) {
            NavigationView {
                TaskDetailView(vm: vm)
            }
        }
    }
}

//struct TaskTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskTileView()
//    }
//}
