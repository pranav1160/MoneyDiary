//
//  AnyTransactionSection.swift
//  MoneyDiary
//
//  Created by Pranav on 26/01/26.
//

import Foundation
import SwiftUI

enum AnyTransactionSection: Identifiable {
    case day(Date, [Transaction])
    case week(Date, [Transaction])
    case month(Date, [Transaction])
    case category(UUID?, [Transaction])
    
    
    var id: String {
        switch self {
        case .day(let d, _): return "day-\(d)"
        case .week(let d, _): return "week-\(d)"
        case .month(let d, _): return "month-\(d)"
        case .category(let id, _): return "cat-\(id?.uuidString ?? "none")"
        }
    }
    
    var transactions: [Transaction] {
        switch self {
        case .day(_, let txs),
                .week(_, let txs),
                .month(_, let txs),
                .category(_, let txs):
            return txs
        }
    }
    
    var totalAmount: Double {
        transactions
            .map { abs($0.amount) }
            .filter { $0.isFinite }
            .reduce(0, +)
    }

}
