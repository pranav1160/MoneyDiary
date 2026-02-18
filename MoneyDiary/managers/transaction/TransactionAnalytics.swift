//
//  TransactionAnalytics.swift
//  MoneyDiary
//
//  Replaces TransactionStore+Queries and TransactionStore+Analytics.
//  Single source of truth for totals, grouping, and time-series data.
//

import Foundation
import SwiftData


// MARK: - TransactionAnalytics

@MainActor
final class TransactionAnalytics {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // ----------------------------------------------------------------
    // MARK: - Base fetch
    //
    // All SwiftData access goes through here.  Predicates that need
    // enum literals or computed Dates are built by the *callers* after
    // lifting values into local variables; this method just executes
    // whatever descriptor it receives.
    // ----------------------------------------------------------------
    
    private func fetch(
        predicate: Predicate<Transaction>? = nil,
        sortBy: [SortDescriptor<Transaction>] = []
    ) -> [Transaction] {
        
        // 1️⃣ Fetch everything matching the user predicate (or all)
        var descriptor = FetchDescriptor<Transaction>(predicate: predicate)
        descriptor.sortBy = sortBy
        
        let fetched = (try? context.fetch(descriptor)) ?? []
        
        // 2️⃣ Filter hidden sources IN MEMORY (SwiftData-safe)
        return fetched.filter {
            $0.sourceRaw != "recurringTemplate" &&
            $0.sourceRaw != "recurringPaused"
        }
    }

    
    // ----------------------------------------------------------------
    // MARK: - "Real" transactions (excludes recurring templates)
    //
    // SwiftData #Predicate cannot reliably filter optionals
    // (recurrenceInfo == nil) or compare against enum literals inline.
    // We fetch everything once and filter in-memory.  For a personal-
    // finance app the dataset is small enough that this is fine.
    // ----------------------------------------------------------------
    
    /// All non-template transactions, newest first.
    private var realTransactions: [Transaction] {
        fetch()
            .filter {
                $0.sourceRaw == "manual" ||
                $0.sourceRaw == "recurringGenerated"
            }
            .sorted { $0.date > $1.date }
    }

    
    // ----------------------------------------------------------------
    // MARK: - Totals
    // ----------------------------------------------------------------
    
    /// Grand total of every real transaction (all time).
    func total() -> Double {
        realTransactions.reduce(0) { $0 + abs($1.amount) }
    }
    
    /// Total within an arbitrary date range.
    func total(from startDate: Date, to endDate: Date = .now) -> Double {
        realTransactions
            .filter { $0.date >= startDate && $0.date <= endDate }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    /// Total for a single category (all time).
    func total(for categoryId: UUID) -> Double {
        realTransactions
            .filter { $0.categoryId == categoryId }
            .reduce(0) { $0 + abs($1.amount) }
    }
    
    // -- Convenience period helpers --
    
    func totalToday() -> Double {
        let start = Calendar.current.startOfDay(for: .now)
        return total(from: start)
    }
    
    func totalThisWeek() -> Double {
        let cal   = Calendar.current
        let start = cal.date(from: cal.dateComponents(
            [.yearForWeekOfYear, .weekOfYear], from: .now
        ))!
        return total(from: start)
    }
    
    func totalThisMonth() -> Double {
        let cal   = Calendar.current
        let start = cal.date(from: cal.dateComponents(
            [.year, .month], from: .now
        ))!
        return total(from: start)
    }
    
    // ----------------------------------------------------------------
    // MARK: - Recent
    // ----------------------------------------------------------------
    
    /// The most recent N real transactions.
    func recent(limit: Int = 5) -> [Transaction] {
        Array(realTransactions.prefix(limit))
    }
    
    // ----------------------------------------------------------------
    // MARK: - Grouping helpers
    // ----------------------------------------------------------------
    
    /// Grouped by calendar day, each group sorted newest-first,
    /// groups themselves sorted latest-day-first.
    func transactionsGroupedByDay()
    -> [(date: Date, transactions: [Transaction])]
    {
       let cal = Calendar.current
       
       let grouped = Dictionary(grouping: realTransactions) { tx in
           cal.startOfDay(for: tx.date)
       }
       
       return grouped
           .map { (date, txs) in
               (date, txs.sorted { $0.date > $1.date })
           }
           .sorted { $0.date > $1.date }
    }
    
    /// Grouped by the start of the ISO week.
    func transactionsGroupedByWeek()
    -> [(weekStart: Date, transactions: [Transaction])]
    {
       let cal = Calendar.current
       
       let grouped = Dictionary(grouping: realTransactions) { tx in
           cal.date(from: cal.dateComponents(
            [.yearForWeekOfYear, .weekOfYear], from: tx.date
           ))!
       }
       
       return grouped
           .map { (weekStart, txs) in
               (weekStart, txs.sorted { $0.date > $1.date })
           }
           .sorted { $0.weekStart > $1.weekStart }
    }
    
    /// Grouped by the first of the month.
    func transactionsGroupedByMonth()
    -> [(monthStart: Date, transactions: [Transaction])]
    {
       let cal = Calendar.current
       
       let grouped = Dictionary(grouping: realTransactions) { tx in
           cal.date(from: cal.dateComponents(
            [.year, .month], from: tx.date
           ))!
       }
       
       return grouped
           .map { (monthStart, txs) in
               (monthStart, txs.sorted { $0.date > $1.date })
           }
           .sorted { $0.monthStart > $1.monthStart }
    }
    
    /// Grouped by categoryId, sorted by each group's total descending.
    func transactionsGroupedByCategory()
    -> [(categoryId: UUID?, transactions: [Transaction])]
    {
       let grouped = Dictionary(grouping: realTransactions, by: \.categoryId)
       
       return grouped
           .map { (categoryId, txs) in
               (categoryId, txs.sorted { $0.date > $1.date })
           }
           .sorted {
               $0.transactions.reduce(0) { $0 + abs($1.amount) } >
               $1.transactions.reduce(0) { $0 + abs($1.amount) }
           }
    }
    
    // ----------------------------------------------------------------
    // MARK: - Time-Series (charts)
    // ----------------------------------------------------------------
    
    /// One data-point per calendar day in [startDate, endDate].
    /// Days with no transactions get amount = 0.
    func dailyTotals(
        from startDate: Date,
        to   endDate: Date = .now
    ) -> [TimeSeriesPoint] {
        let cal   = Calendar.current
        let start = cal.startOfDay(for: startDate)
        let lastDay = cal.startOfDay(for: endDate)
        
        let grouped = Dictionary(
            grouping: realTransactions.filter {
                $0.date >= start && $0.date <= endDate
            }
        ) { cal.startOfDay(for: $0.date) }
        
        var result: [TimeSeriesPoint] = []
        var current = start
        
        while current <= lastDay {
            let amount = grouped[current]?.reduce(0) {
                $0 + abs($1.amount)
            } ?? 0
            result.append(TimeSeriesPoint(date: current, amount: amount))
            current = cal.date(byAdding: .day, value: 1, to: current)!
        }
        
        return result
    }
    
    /// One data-point per week for the last N weeks.
    func weeklyTotals(weeks: Int = 4) -> [TimeSeriesPoint] {
        let cal = Calendar.current
        let now = Date()
        
        // Build the list of week-start dates we want to show.
        var allWeeks: [Date] = []
        for i in (0..<weeks).reversed() {
            guard let weekDate = cal.date(byAdding: .weekOfYear, value: -i, to: now),
                  let weekStart = cal.date(from: cal.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear], from: weekDate
                  )) else { continue }
            allWeeks.append(weekStart)
        }
        
        // Group all real transactions by their week-start.
        let grouped = Dictionary(grouping: realTransactions) { tx -> Date in
            cal.date(from: cal.dateComponents(
                [.yearForWeekOfYear, .weekOfYear], from: tx.date
            ))!
        }
        
        return allWeeks.map { weekStart in
            let amount = grouped[weekStart]?.reduce(0) { $0 + abs($1.amount) } ?? 0
            return TimeSeriesPoint(date: weekStart, amount: amount)
        }
    }
    
    /// One data-point per month for the last N months.
    func monthlyTotals(months: Int = 6) -> [TimeSeriesPoint] {
        let cal = Calendar.current
        let now = Date()
        
        var allMonths: [Date] = []
        for i in (0..<months).reversed() {
            guard let monthDate  = cal.date(byAdding: .month, value: -i, to: now),
                  let monthStart = cal.date(from: cal.dateComponents(
                    [.year, .month], from: monthDate
                  )) else { continue }
            allMonths.append(monthStart)
        }
        
        let grouped = Dictionary(grouping: realTransactions) { tx -> Date in
            cal.date(from: cal.dateComponents([.year, .month], from: tx.date))!
        }
        
        return allMonths.map { monthStart in
            let amount = grouped[monthStart]?.reduce(0) { $0 + abs($1.amount) } ?? 0
            return TimeSeriesPoint(date: monthStart, amount: amount)
        }
    }
    
    // ----------------------------------------------------------------
    // MARK: - Category Aggregates (pie / breakdown charts)
    // ----------------------------------------------------------------
    
    /// Top categories within an arbitrary date range.
    private func topCategories(
        from startDate: Date,
        to   endDate:   Date = .now
    ) -> [CategoryAggregate] {
        let filtered = realTransactions.filter {
            $0.date >= startDate && $0.date <= endDate
        }
        
        let grouped = Dictionary(grouping: filtered, by: \.categoryId)
        
        return grouped
            .map { (categoryId, txs) in
                CategoryAggregate(
                    id:    categoryId,
                    total: txs.reduce(0) { $0 + abs($1.amount) }
                )
            }
            .sorted { $0.total > $1.total }
    }
    
    func topCategoriesLast7Days() -> [CategoryAggregate] {
        let start = Calendar.current.date(byAdding: .day, value: -6, to: .now)!
        return topCategories(from: start)
    }
    
    /// One [CategoryAggregate] array per week, last 4 weeks, oldest first.
    func topCategoriesLast4Weeks() -> [[CategoryAggregate]] {
        let cal = Calendar.current
        let now = Date()
        
        return (0..<4).reversed().compactMap { offset -> [CategoryAggregate]? in
            guard let weekDate  = cal.date(byAdding: .weekOfYear, value: -offset, to: now),
                  let start     = cal.date(from: cal.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear], from: weekDate
                  )),
                  let end       = cal.date(byAdding: .day, value: 7, to: start)
            else { return nil }
            
            return topCategories(from: start, to: end)
        }
    }
    
    /// One [CategoryAggregate] array per month, last 6 months, oldest first.
    func topCategoriesLast6Months() -> [[CategoryAggregate]] {
        let cal = Calendar.current
        let now = Date()
        
        return (0..<6).reversed().compactMap { offset -> [CategoryAggregate]? in
            guard let monthDate = cal.date(byAdding: .month, value: -offset, to: now),
                  let start     = cal.date(from: cal.dateComponents(
                    [.year, .month], from: monthDate
                  )),
                  let end       = cal.date(byAdding: .month, value: 1, to: start)
            else { return nil }
            
            return topCategories(from: start, to: end)
        }
    }
}
