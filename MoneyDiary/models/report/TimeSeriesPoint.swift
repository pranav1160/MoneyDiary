//
//  TimeSeriesPoint.swift
//  MoneyDiary
//
//  Created by Pranav on 24/01/26.
//


// TimeSeriesPoint.swift

import Foundation

struct TimeSeriesPoint: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let amount: Double

    init(date: Date, amount: Double) {
        self.id = UUID()
        self.date = date
        self.amount = amount
    }
}
