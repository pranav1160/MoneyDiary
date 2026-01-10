//
//  Date+EXT.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import Foundation

extension Date {
    static func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date())!
    }
}
