//
//  Firestore+CollectionRef.swift
//  SchoolVerse
//
//  Created by Steven Yu on 10/12/22.
//

import FirebaseFirestore

// source: https://medium.com/@karsonbraaten/swift-and-firestore-query-for-fields-with-todays-date-d07bea56c79d
extension CollectionReference {
    func whereField(_ field: String, isDateInToday value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        else {
            fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
}
