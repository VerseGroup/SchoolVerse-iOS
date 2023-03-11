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
                .foregroundColor(Color.white)
                .font(.system(size: 30))
                .padding(.leading, 5)
                .onTapGesture {
                    withAnimation(.easeIn) {
                        self.vm.task.completed.toggle()
                    }
                }
            
            VStack(alignment: .leading) {
                Text(vm.task.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Text(vm.task.courseName)
                    .font(.caption)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                    
                    Text(vm.task.dueDate.weekDateTimeString())
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
            .onTapGesture {
                showTaskDetailView.toggle()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .padding()
        .padding(.leading, 10)
        .glassCardFull()
        .sheet(isPresented: $showTaskDetailView) {
            NavigationStack {
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
