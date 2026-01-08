//
//  Date+EXT.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import Foundation

extension Date {
    func daysAgo(_ days: Int, calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: .day, value: -days, to: self) ?? self
    }
}

