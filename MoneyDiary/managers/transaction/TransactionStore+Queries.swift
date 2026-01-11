//
//  TransactionStore+Queries.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import Foundation




//QUERIES
extension TransactionStore {
    
    //returns total expense
    func total() -> Double {
        transactions
            .reduce(0) { sum, tx in
                sum + abs(tx.amount)
            }
    }
    
    //DATE-BASED TOTAL
    func total(
        from startDate: Date,
        to endDate: Date = .now
    ) -> Double {
        transactions
            .filter {
                $0.date >= startDate &&
                $0.date <= endDate
            }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    //CATEGORY-BASED QUERIES
    func total(
        for categoryId: UUID,
    ) -> Double {
        transactions
            .filter {
                $0.categoryId == categoryId
            }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    //CONVENIENCE PERIOD HELPERS
    func totalThisMonth() -> Double {
        let start = Calendar.current
            .date(from: Calendar.current.dateComponents([.year, .month], from: .now))!
        return total(from: start)
    }
    
    func totalThisWeek() -> Double {
        let start = Calendar.current
            .date(from: Calendar.current.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: .now
            ))!
        return total(from: start)
    }
    
    func totalToday() -> Double {
        let start = Calendar.current.startOfDay(for: .now)
        return total( from: start)
    }
    
    
    
    
    //RECENT TRANSACTIONS
    func recent(
        limit: Int = 5
    ) -> [Transaction] {
        Array(transactions.prefix(limit))
    }

}

