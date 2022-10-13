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
                HStack {
                    // go to previous day
                    Button {
                        withAnimation(.easeInOut) {
                            vm.updateSelectedMenu(date: Calendar.current.date(byAdding: .day, value: -1, to: vm.selectedDate) ?? Date())
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(.white)
                    .bold()
                    .padding(2)
                    
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
                    }
                    .foregroundColor(.white)
                    .bold()
                    .padding(2)
                }
                .padding()
                
                VStack(spacing: 20) {
                    if let menu = vm.selectedMenu {
//                        Picker("", selection: $selectedMeal) {
//                            ForEach(Meal.allCases, id:\.self) { meal in
//                                Text(meal.rawValue)
//                                    .foregroundColor(.white)
//                                    .tag(meal)
//                            }
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                        .padding(.horizontal)
                        
                        HStack (spacing: 20) {
                            ForEach (Meal.allCases, id: \.self) { meal in
                                Text(meal.rawValue)
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 2)
                                    .background (
                                        ZStack {
                                            if meal == selectedMeal {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(.clear)
                                                    .padding(25)
                                                    .padding(.horizontal)
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
                        .padding()
                        .padding(.vertical, 5)
                        .heavyGlass()
                        
                        
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
            
            DatePicker("", selection: $vm.selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .tint(accentColor)
                .frame(width: 310, height: 300)
                .clipped()
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 25, style: .continuous)
                )
                .opacity(showPicker ? 1 : 0 )
                .offset(x: 0, y: -100)
                .onChange(of: vm.selectedDate) { _ in
                    withAnimation {
                        showPicker = false
                    }
                }
        }
        .navigationTitle("Menus")
    }
}

struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenusView()
    }
}

extension MenusView {
    
}
