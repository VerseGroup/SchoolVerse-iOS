//
//  ContentView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 8/31/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(CustomEnvironment.firebasePlist)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
