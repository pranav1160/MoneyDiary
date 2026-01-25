//
//  TransactionStore+Analytics.swift
//  MoneyDiary
//
//  Analytics and graphing queries
//

import Foundation

extension TransactionStore {
    
    // MARK: - Time-Series Data
    
    /// Daily totals for a date range (useful for line/bar charts)
    func dailyTotals(
        from startDate: Date,
        to endDate: Date = .now
    ) -> [TimeSeriesPoint] {
        
        let calendar = Calendar.current
        
        let start = calendar.startOfDay(for: startDate)
        let end = endDate   // 🔥 DO NOT truncate
        
        let grouped = Dictionary(grouping: realTransactions.filter {
            $0.date >= start && $0.date <= end
        }) {
            calendar.startOfDay(for: $0.date)
        }
        
        var result: [TimeSeriesPoint] = []
        var current = start
        let lastDay = calendar.startOfDay(for: end)
        
        while current <= lastDay {
            let amount = grouped[current]?.reduce(0) {
                $0 + abs($1.amount)
            } ?? 0
            
            result.append(
                TimeSeriesPoint(date: current, amount: amount)
            )
            
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        
        return result
    }


    
    /// Monthly totals for the past N months
    func monthlyTotals(months: Int = 6) -> [TimeSeriesPoint] {
        let calendar = Calendar.current
        let now = Date()
        
        // Generate all months in range
        var allMonths: [Date] = []
        for i in (0..<months).reversed() {
            if let monthDate = calendar.date(byAdding: .month, value: -i, to: now) {
                let components = calendar.dateComponents([.year, .month], from: monthDate)
                if let monthStart = calendar.date(from: components) {
                    allMonths.append(monthStart)
                }
            }
        }
        
        // Group transactions by month
        let grouped = Dictionary(grouping: realTransactions) { tx -> Date in
            let components = calendar.dateComponents([.year, .month], from: tx.date)
            return calendar.date(from: components)!
        }
        
        // Map all months to their totals (0 if no transactions)
        return allMonths.map { monthDate in
            let amount = grouped[monthDate]?.reduce(0) { $0 + abs($1.amount) } ?? 0
            return TimeSeriesPoint(date: monthDate, amount: amount)
        }
    }
    
    
    /// Weekly totals for the past N weeks
    func weeklyTotals(weeks: Int = 4) -> [TimeSeriesPoint] {
        let calendar = Calendar.current
        let now = Date()
        
        // Generate all weeks in range
        var allWeeks: [Date] = []
        for i in (0..<weeks).reversed() {
            if let weekDate = calendar.date(byAdding: .weekOfYear, value: -i, to: now) {
                let components = calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: weekDate
                )
                if let weekStart = calendar.date(from: components) {
                    allWeeks.append(weekStart)
                }
            }
        }
        
        // Group transactions by week
        let grouped = Dictionary(grouping: realTransactions) { tx -> Date in
            let components = calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: tx.date
            )
            return calendar.date(from: components)!
        }
        
        // Map all weeks to their totals (0 if no transactions)
        return allWeeks.map { weekDate in
            let amount = grouped[weekDate]?.reduce(0) { $0 + abs($1.amount) } ?? 0
            return TimeSeriesPoint(date: weekDate, amount: amount)
        }
    }
    
    
    //MARK: - categories
    
    private func topCategories(
        from startDate: Date,
        to endDate: Date = .now
    ) -> [CategoryAggregate] {
        
        let filtered = realTransactions.filter {
            $0.date >= startDate && $0.date <= endDate
        }
        
        let grouped = Dictionary(grouping: filtered, by: \.categoryId)
        
        return grouped
            .map { categoryId, txs in
                CategoryAggregate(
                    id: categoryId,
                    total: txs.reduce(0) { $0 + abs($1.amount) }
                )
            }
            .sorted { $0.total > $1.total }
    }
    
    func topCategoriesLast7Days() -> [CategoryAggregate] {
        let calendar = Calendar.current
        let start = calendar.date(byAdding: .day, value: -6, to: .now)!
        return topCategories(from: start)
    }
    
    func topCategoriesLast4Weeks() -> [[CategoryAggregate]] {
        let calendar = Calendar.current
        let now = Date()
        
        return (0..<4).reversed().compactMap { offset in
            guard
                let weekStart = calendar.date(
                    byAdding: .weekOfYear,
                    value: -offset,
                    to: now
                ),
                let start = calendar.date(
                    from: calendar.dateComponents(
                        [.yearForWeekOfYear, .weekOfYear],
                        from: weekStart
                    )
                ),
                let end = calendar.date(byAdding: .day, value: 7, to: start)
            else { return nil }
            
            return topCategories(from: start, to: end)
        }
    }
    
    func topCategoriesLast6Months() -> [[CategoryAggregate]] {
        let calendar = Calendar.current
        let now = Date()
        
        return (0..<6).reversed().compactMap { offset in
            guard
                let monthDate = calendar.date(byAdding: .month, value: -offset, to: now),
                let start = calendar.date(
                    from: calendar.dateComponents([.year, .month], from: monthDate)
                ),
                let end = calendar.date(byAdding: .month, value: 1, to: start)
            else { return nil }
            
            return topCategories(from: start, to: end)
        }
    }
    
}
