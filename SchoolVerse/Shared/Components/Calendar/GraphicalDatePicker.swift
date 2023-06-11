//
//  GraphicalDatePicker.swift
//  SchoolVerse
//
//  Created by dshola-philips on 11/24/22.
//

import SwiftUI

struct GraphicalDatePicker: View {
    @Binding var selectedDate : Date
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 15)
            
            HStack {
                Spacer()
                
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .scaledToFit()
                        .frame(
                            width: 30,
                            height: 30
                        )
                }
                .padding([.trailing, .vertical])
            }
            
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
            
            Spacer()
        }
        .if(UIDevice.current.userInterfaceIdiom == .pad) { view in
            view
                .frame(width: 400, height: 500)
        }
        .onChange(of: selectedDate) { _ in
            withAnimation {
                isPresented = false
            }
        }
        .clearModalBackground() // in ios 16.4 depreciate and use .presentationBackground(.clear)
        .background(
            .thinMaterial,
            in: RoundedRectangle(cornerRadius: 25, style: .continuous)
        )
        .ignoresSafeArea(edges: .bottom)
    }
}
