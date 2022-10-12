//
//  FoodView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI


struct FoodView: View {
    let food: Food
    
    var body: some View {
        DisclosureGroup {
            VStack(spacing: 10) {
                servingSize
                nutritionInfo
                ingredients
            }
            .padding(5)
        } label: {
            HeaderLabel(name: food.name)
        }
        .foregroundColor(Color.white)
        .tint(Color.white)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .taintedGlass()
    }
}

extension FoodView {
    var servingSize: some View {
        HStack { // Serving Size
            Text("Serving Size")
                .fontWeight(.bold)
            
            Spacer()
            
            Text("\(food.servingSize.servingSizeAmount ?? "N/A")" + "  \(food.servingSize.servingSizeUnit ?? "N/A")")
                .fontWeight(.semibold)
                .padding(.trailing, 7)
            
        }
        .padding(.horizontal, 5)
    }
    
    var nutritionInfo: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Nutrition Info")
                .fontWeight(.bold)
            
            HStack {
                Text("Calories")
                
                Spacer()
                
                Text("\(food.nutrition.calories?.formatted() ?? "N/A") cal")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 7)
            
            HStack {
                Text("Total Fat")
                
                Spacer()
                
                Text("\(food.nutrition.gramsFat?.formatted() ?? "N/A") g")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 7)
            
            HStack {
                Text("Total Carbs")
                
                Spacer()
                
                Text("\(food.nutrition.gramsCarbs?.formatted() ?? "N/A") g")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 7)
            
            HStack {
                Text("Protein")
                
                Spacer()
                
                Text("\(food.nutrition.gramsProtein?.formatted() ?? "N/A") g")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 7)
            
            HStack {
                Text("Sugar")

                Spacer()

                Text("\(food.nutrition.gramsSugar?.formatted() ?? "N/A") g")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 7)
            
            HStack {
                Text("Sodium")

                Spacer()

                Text("\(food.nutrition.mgSodium?.formatted() ?? "N/A") mg")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 7)
        }
        .padding(.horizontal, 5)
    }
    
    var ingredients: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Ingredients")
                .fontWeight(.bold)
            
            HStack {
                Text(food.ingredients)
                Spacer()
            }
            .padding(.horizontal, 7)
        }
        .padding(.horizontal, 5)
    }
}
