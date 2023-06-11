//
//  MenusView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/1/22.
//

import SwiftUI

enum Meal: String, CaseIterable, Hashable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
}

struct MenusView: View {
    @StateObject var vm = MenusListViewModel()
    
    @State var showPicker: Bool = false
    @State var selectedMeal: Meal = .lunch
    
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            // if iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad){
                ColorfulBackgroundView()
            }
            
            // if ipad
            if UIDevice.current.userInterfaceIdiom == .pad {
                ClearBackgroundView()
            }
            
            VStack {
                
                WeeksTabView { week in
                    WeekView(week: week)
                }
                
                VStack(spacing: 5) {
                    if let menu = vm.selectedMenu {
                        
                        // if iphone
                        if !(UIDevice.current.userInterfaceIdiom == .pad){
                            
                            HStack (spacing: 20) {
                                ForEach (Meal.allCases, id: \.self) { meal in
                                    Text(meal.rawValue)
                                        .fontWeight(.semibold)
                                        .font(.headline)
                                        .frame(width: UIScreen.main.bounds.width / 4.5)
                                        .background (
                                            ZStack {
                                                if meal == selectedMeal {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(.clear)
                                                        .padding(20)
                                                        .taintedGlass()
                                                        .matchedGeometryEffect(id: "currentMeal", in: animation)
                                                } //: if
                                            } //: Zstack
                                        ) //: background
                                        .onTapGesture {
                                            withAnimation {
                                                selectedMeal = meal
                                            }
                                        }
                                } //: ForEach
                            } //: HStack
                            .padding(.vertical, 15)
                            .padding(.horizontal, 5)
                            .cornerRadius(20)
                            .heavyGlass()
                            .padding(.bottom)
                            
                        } else {
                            
                            HStack (spacing: 20) {
                                ForEach (Meal.allCases, id: \.self) { meal in
                                    Text(meal.rawValue)
                                        .fontWeight(.semibold)
                                        .font(.headline)
                                        .frame(width: UIScreen.main.bounds.width / 6)
                                        .background (
                                            ZStack {
                                                if meal == selectedMeal {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(.clear)
                                                        .padding(20)
                                                        .taintedGlass()
                                                        .matchedGeometryEffect(id: "currentMeal", in: animation)
                                                } //: if
                                            } //: Zstack
                                        ) //: background
                                        .onTapGesture {
                                            withAnimation {
                                                selectedMeal = meal
                                            }
                                        }
                                } //: ForEach
                            } //: HStack
                            .padding(.vertical, 15)
                            .padding(.horizontal, 5)
                            .cornerRadius(20)
                            .heavyGlass()
                            .padding(.bottom)
                            
                        }
                        
                        switch selectedMeal {
                        case .breakfast:
                            MealView(meal: menu.breakfast, mealType: "Breakfast")
                        case .lunch:
                            MealView(meal: menu.lunch, mealType: "Lunch")
                        case .dinner:
                            MealView(meal: menu.dinner, mealType: "Dinner")
                        }
                    } else {
                        VStack {
                            Spacer()
                            Text("No Menus Today!")
                                .fontWeight(.semibold)
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                            Spacer()
                            Spacer()
                        }
                        .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            .onTapGesture {
                withAnimation {
                    showPicker = false
                }
            }
        }
        .navigationTitle("Menus")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button {
                    showPicker.toggle()
                } label: {
                    NavButtonView(systemName: "calendar")
                }
            })
        }
        .sheet(isPresented: $showPicker) {
            ZStack {
                if(UIDevice.current.userInterfaceIdiom == .pad) {
                    ClearBackgroundView()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            showPicker.toggle()
                        }
                }
                
                GraphicalDatePicker(selectedDate: $vm.weekStore.selectedDate, isPresented: $showPicker)
            }
            .presentationDetents([.medium])
        }
        .environmentObject(vm.weekStore)
    }
}

struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenusView()
    }
}
