//
//  TransactionStore+Queries.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import Foundation


//BASIC TOTALS
extension TransactionStore {
    
    func totalIncome() -> Double {
        total(for: .income)
    }
    
    func totalExpense() -> Double {
        total(for: .expense)
    }
    
    func netBalance() -> Double {
        totalIncome() - totalExpense()
    }
}

//QUERIES
extension TransactionStore {
    
    func total(for type: TransactionType) -> Double {
        transactions
            .filter { $0.transactionType == type }
            .reduce(0) { sum, tx in
                sum + abs(tx.amount)
            }
    }
    
    //DATE-BASED TOTAL
    func total(
        for type: TransactionType,
        from startDate: Date,
        to endDate: Date = .now
    ) -> Double {
        transactions
            .filter {
                $0.transactionType == type &&
                $0.date >= startDate &&
                $0.date <= endDate
            }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    //CATEGORY-BASED QUERIES
    func total(
        for categoryId: UUID,
        type: TransactionType? = nil
    ) -> Double {
        transactions
            .filter {
                $0.categoryId == categoryId &&
                (type == nil || $0.transactionType == type)
            }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    //CONVENIENCE PERIOD HELPERS
    func totalThisMonth(for type: TransactionType) -> Double {
        let start = Calendar.current
            .date(from: Calendar.current.dateComponents([.year, .month], from: .now))!
        return total(for: type, from: start)
    }
    
    func totalThisWeek(for type: TransactionType) -> Double {
        let start = Calendar.current
            .date(from: Calendar.current.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: .now
            ))!
        return total(for: type, from: start)
    }
    
    func totalToday(for type: TransactionType) -> Double {
        let start = Calendar.current.startOfDay(for: .now)
        return total(for: type, from: start)
    }
    
    
    
    
    //RECENT TRANSACTIONS
    func recent(
        limit: Int = 5
    ) -> [Transaction] {
        Array(transactions.prefix(limit))
    }

}

