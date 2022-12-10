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
        Text("Work in Progress")
            .font(.system(size: 20))
            .fontWeight(.bold)
    }
}
