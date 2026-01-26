//
//  TransactionStore+Queries.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import Foundation
//QUERIES
extension TransactionStore {
    
    var realTransactions: [Transaction] {
        transactions.filter { $0.recurrenceInfo == nil }
    }

    
    //returns total expense
    func total() -> Double {
        realTransactions
            .reduce(0) { sum, tx in
                sum + abs(tx.amount)
            }
    }
    
    //DATE-BASED TOTAL
    func total(
        from startDate: Date,
        to endDate: Date = .now
    ) -> Double {
        realTransactions
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
        realTransactions
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
        Array(realTransactions.prefix(limit))
    }
    
    
    /// Transactions grouped by start-of-day, sorted by date DESC
    func transactionsGroupedByDay() -> [(date: Date, transactions: [Transaction])] {
        
        let calendar = Calendar.current
        
        let grouped = Dictionary(
            grouping: realTransactions
        ) { tx in
            calendar.startOfDay(for: tx.date)
        }
        
        return grouped
            .map { date, txs in
                (
                    date,
                    txs.sorted { $0.date > $1.date } // newest first inside day
                )
            }
            .sorted { $0.date > $1.date } // latest day first
    }
    
    /// Transactions grouped by start-of-week, sorted DESC
    func transactionsGroupedByWeek()
    -> [(weekStart: Date, transactions: [Transaction])] {
        
        let calendar = Calendar.current
        
        let grouped = Dictionary(
            grouping: realTransactions
        ) { tx in
            calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: tx.date
                )
            )!
        }
        
        return grouped
            .map { weekStart, txs in
                (
                    weekStart,
                    txs.sorted { $0.date > $1.date }
                )
            }
            .sorted { $0.weekStart > $1.weekStart }
    }

    /// Transactions grouped by start-of-month, sorted DESC
    func transactionsGroupedByMonth()
    -> [(monthStart: Date, transactions: [Transaction])] {
        
        let calendar = Calendar.current
        
        let grouped = Dictionary(
            grouping: realTransactions
        ) { tx in
            calendar.date(
                from: calendar.dateComponents([.year, .month], from: tx.date)
            )!
        }
        
        return grouped
            .map { monthStart, txs in
                (
                    monthStart,
                    txs.sorted { $0.date > $1.date }
                )
            }
            .sorted { $0.monthStart > $1.monthStart }
    }

    /// Transactions grouped by category
    func transactionsGroupedByCategory()
    -> [(categoryId: UUID?, transactions: [Transaction])] {
        
        let grouped = Dictionary(
            grouping: realTransactions
        ) { tx in
            tx.categoryId
        }
        
        return grouped
            .map { categoryId, txs in
                (
                    categoryId,
                    txs.sorted { $0.date > $1.date }
                )
            }
            .sorted {
                ($0.transactions.reduce(0) { $0 + abs($1.amount) }) >
                ($1.transactions.reduce(0) { $0 + abs($1.amount) })
            }
    }
    
   

}

