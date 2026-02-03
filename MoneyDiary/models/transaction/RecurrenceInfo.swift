//
//  RecurrenceInfo.swift
//  MoneyDiary
//
//  Created by Pranav on 16/01/26.
//

import Foundation

enum RecurrencePattern: String, Codable, Equatable {
    case daily
    case weekly
    case monthly
    case customDays
    
    var description: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .customDays: return "Fixed days"
        }
    }
}


struct RecurrenceInfo: Codable, Equatable {
    let pattern: RecurrencePattern
    let intervalDays: Int?        // only for .customDays
    let nextOccurrence: Date
    let lastProcessed: Date?
    
    init(
        pattern: RecurrencePattern,
        intervalDays: Int? = nil,
        nextOccurrence: Date,
        lastProcessed: Date? = nil
    ) {
        self.pattern = pattern
        self.intervalDays = intervalDays
        self.nextOccurrence = nextOccurrence
        self.lastProcessed = lastProcessed
    }
    
    func updatingNextOccurrence() -> RecurrenceInfo {
        let calendar = Calendar.current
        
        let newNext: Date = {
            switch pattern {
            case .daily:
                return calendar.date(byAdding: .day, value: 1, to: nextOccurrence)!
                
            case .weekly:
                return calendar.date(byAdding: .weekOfYear, value: 1, to: nextOccurrence)!
                
            case .monthly:
                return calendar.date(byAdding: .month, value: 1, to: nextOccurrence)!
                
            case .customDays:
                return calendar.date(
                    byAdding: .day,
                    value: intervalDays ?? 1,
                    to: nextOccurrence
                )!
            }
        }()
        
        return RecurrenceInfo(
            pattern: pattern,
            intervalDays: intervalDays,
            nextOccurrence: newNext,
            lastProcessed: Date()
        )
    }
}

