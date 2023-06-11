//
//  WeekView.swift
//  SchoolVerse
//
//  Created by Steven Yu on 5/31/23.
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var weekStore: WeekStore
    
    @AppStorage("accent_color") var accentColor: Color = .accent.blue
    
    @Namespace var animation

    var week: Week

//    var body: some View {
//        HStack {
//            ForEach(0..<7) { i in
//                VStack {
//                    Text(week.dates[i].weekDayString())
//                        .font(.system(size: 14))
//                        .fontWeight(.semibold)
//                        .frame(maxWidth:.infinity)
//
//                    Spacer()
//                        .frame(height: 4)
//
//                    ZStack {
//                        HStack{
//                            Spacer()
//                                .frame(width: 5)
//
//                            Circle()
//                                .foregroundColor(week.dates[i].hasSame(.day, as: week.referenceDate) ? accentColor : .clear)
//
//                            Spacer()
//                                .frame(width: 5)
//                        }
//
//                        Text(week.dates[i].dateNumberString())
////                            .font(.system(size: 16))
//                            .frame(maxWidth: .infinity)
//                            .foregroundColor(week.dates[i].hasSame(.day, as: week.referenceDate) ? .white : .primary)
//                    }
//                }
//                .onTapGesture {
//                    withAnimation {
//                        weekStore.selectedDate = week.dates[i]
//                    }
//                }
//                .frame(maxWidth: .infinity)
//            }
//        }
//        .padding()
//    }
    
    var body: some View {
        HStack {
            ForEach(0..<7) { i in
                VStack(spacing: 10) {
                    Text(week.dates[i].weekDayString())
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)

                    Text(week.dates[i].dateNumberString())
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)

                    Circle()
                        .fill(.white)
                        .frame(width: 8)
                        .opacity(week.dates[i].sameDay(as: Date.now) ? 1 : 0)
                }
                .background(
                    ZStack{
                        if week.dates[i].sameDay(as: week.referenceDate) {
                            Capsule()
                                .fill(.clear)
                                .taintedGlass()
                                .frame(width: 45, height: 95)
                                .matchedGeometryEffect(id: "currentday", in: animation)
                        }
                    }
                )
                .onTapGesture {
                    withAnimation {
                        weekStore.selectedDate = week.dates[i]
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
    
}
