//
//  AlertViewPopover.swift
//  SchoolVerse
//
//  Created by Steven Yu on 9/19/22.
//

import SwiftUI
import Popovers

// TODO: finish implementing with viewmodifier 

public extension View {
    
}

struct AlertViewPopover: View {
    @Binding var present: Bool
    @Binding var expanding: Bool
    
    @Binding var alertTitle: String
    @Binding var alertDescription: String

    /// the initial animation
    @State var scaled = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text(alertTitle)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)

                Text(alertDescription)
                    .multilineTextAlignment(.center)
            }
            .padding()

            Divider()

            Button {
                present = false
            } label: {
                Text("Ok")
                    .foregroundColor(.blue)
            }
            .buttonStyle(Templates.AlertButtonStyle())
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .popoverShadow(shadow: .system)
        .frame(width: 260)
        .scaleEffect(expanding ? 1.05 : 1)
        .scaleEffect(scaled ? 2 : 1)
        .opacity(scaled ? 0 : 1)
        .onAppear {
            withAnimation(.spring(
                response: 0.4,
                dampingFraction: 0.9,
                blendDuration: 1
            )) {
                scaled = false
            }
        }
    }
}
