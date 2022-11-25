//
//  GraphicalDatePicker.swift
//  SchoolVerse
//
//  Created by dshola-philips on 11/24/22.
//

import SwiftUI

struct GraphicalDatePicker: View {
    @Binding var selectedDate : Date
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .tint(accentColor)
                
            Button(action: {
                selectedDate = Date.now
            }, label: {
                Text("Jump To Today")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .padding()
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(accentColor)
                        .padding(5)
                    )
            })
            
        }
        .frame(width: 320, height: 380)
        .clipped()
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 25, style: .continuous)
        )
        .opacity(isPresented ? 1 : 0 )
        .offset(x: UIScreen.main.bounds.width/9, y: -UIScreen.main.bounds.height/6)
        .onChange(of: selectedDate) { _ in
            withAnimation {
                isPresented = false
            }
        }
    }
}
