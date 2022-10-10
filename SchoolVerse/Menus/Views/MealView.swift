//
//  MealView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/10/22.
//

import SwiftUI

struct MealView: View {
    let meal: [Food]
    let mealType: String
    
    var body: some View {
        if !meal.isEmpty {
            VStack {
                Spacer()
                    .frame(height: 20)
                
                ScrollView(showsIndicators: false) {
                    ForEach(meal, id: \.self) { food in
                        FoodView(food: food)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    
                    Spacer()
                        .frame(height: 95)
                }
            }
            .frame(maxWidth: .infinity)
            .heavyGlass()
        } else {
            VStack {
                Spacer()
                    .frame(height: 20)
                
                Text("No \(mealType) for Today!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .heavyGlass()
        }
    }
}
