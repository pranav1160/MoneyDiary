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
    
    init(pattern: RecurrencePattern, startDate: Date = Date()) {
        self.pattern = pattern
        self.nextOccurrence = startDate
        self.lastProcessed = nil
    }
    
    init(pattern: RecurrencePattern, nextOccurrence: Date, lastProcessed: Date?) {
        self.pattern = pattern
        self.nextOccurrence = nextOccurrence
        self.lastProcessed = lastProcessed
    }
    
    func updatingNextOccurrence() -> RecurrenceInfo {
        let calendar = Calendar.current
        let newNext: Date
        
        switch pattern {
        case .daily:
            newNext = calendar.date(byAdding: .day, value: 1, to: nextOccurrence) ?? nextOccurrence
        case .weekly:
            newNext = calendar.date(byAdding: .day, value: 7, to: nextOccurrence) ?? nextOccurrence
        case .monthly:
            newNext = calendar.date(byAdding: .month, value: 1, to: nextOccurrence) ?? nextOccurrence
        case .customDays(let days):
            newNext = calendar.date(byAdding: .day, value: days, to: nextOccurrence) ?? nextOccurrence
        }
        
        return RecurrenceInfo(
            pattern: pattern,
            nextOccurrence: newNext,
            lastProcessed: Date()
        )
    }
}
