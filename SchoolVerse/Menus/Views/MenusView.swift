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
    
    @AppStorage("accent_color") var accentColor: Color = .accent.cyan
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            ColorfulBackgroundView()
            
            VStack {
                dateSelector
                
                VStack(spacing: 5) {
                    if let menu = vm.selectedMenu {
                        
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
            
            // iphone
            if !(UIDevice.current.userInterfaceIdiom == .pad) {
                GraphicalDatePicker(selectedDate: $vm.selectedDate, isPresented: $showPicker)
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
    }
}

struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenusView()
    }
}

extension MenusView {
    var dateSelector: some View {
        HStack {
            // go to previous day
            Button {
                withAnimation(.easeInOut) {
                    vm.updateSelectedMenu(date: Calendar.current.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date())
                }
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 50, height: 50)
            }
            .foregroundColor(.white)
            .bold()
            .padding(5)
            
            Spacer()
            
            Button {
                withAnimation {
                    showPicker.toggle()
                }
            }  label: {
                Text(vm.selectedDate.weekDateString())
                    .fontWeight(.semibold)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .glassCardFull()
            }
            
            Spacer()
            
            // go to next day
            Button {
                withAnimation {
                    vm.updateSelectedMenu(date: Calendar.current.date(byAdding: .day, value: 1, to: vm.selectedDate) ?? Date())
                }
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 50, height: 50)
            }
            .foregroundColor(.white)
            .bold()
            .padding(5)
        }
    }
}
