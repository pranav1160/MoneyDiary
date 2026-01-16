//
//  RecurrenceInfo.swift
//  MoneyDiary
//
//  Created by Pranav on 16/01/26.
//

import Foundation

enum RecurrencePattern: Codable, Equatable {
    case daily
    case weekly
    case monthly
    case customDays(intervalDays: Int)
    
    var description: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .customDays(let days): return "Every \(days) days"
        }
    }
}


struct RecurrenceInfo: Codable, Equatable {
    let pattern: RecurrencePattern
    let nextOccurrence: Date
    let lastProcessed: Date?
    
    init(
        pattern: RecurrencePattern,
        nextOccurrence: Date,
        lastProcessed: Date? = nil
    ) {
        self.pattern = pattern
        self.nextOccurrence = nextOccurrence
        self.lastProcessed = lastProcessed
    }
    
    func updatingNextOccurrence() -> RecurrenceInfo {
        let newNext = pattern.nextDate(after: nextOccurrence)
        
        return RecurrenceInfo(
            pattern: pattern,
            nextOccurrence: newNext,
            lastProcessed: Date()
        )
    }
}



extension RecurrencePattern {
    func nextDate(after date: Date) -> Date {
        let calendar = Calendar.current
        
        switch self {
        case .daily:
            return calendar.date(byAdding: .day, value: 1, to: date)!
        case .weekly:
            return calendar.date(byAdding: .day, value: 7, to: date)!
        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: date)!
        case .customDays(let days):
            return calendar.date(byAdding: .day, value: days, to: date)!
        }
    }
}
