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
        
        let filtered = realTransactions.filter {
            $0.date >= startDate && $0.date <= endDate
        }
        
        let grouped = Dictionary(grouping: filtered) {
            calendar.startOfDay(for: $0.date)
        }
        
        return grouped
            .map { date, txs in
                TimeSeriesPoint(
                    date: date,
                    amount: txs.reduce(0) { $0 + abs($1.amount) }
                )
            }
            .sorted { $0.date < $1.date }
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

    
    // MARK: - Category Breakdowns
    
    /// Total spending per category (for pie charts)
    func totalsByCategory() -> [(categoryId: UUID, amount: Double)] {
        let grouped = Dictionary(grouping: realTransactions) { $0.categoryId }
        
        let mapped = grouped.map { categoryId, txs -> (UUID, Double) in
            let sum = txs.reduce(0) { $0 + abs($1.amount) }
            return (categoryId, sum)
        }
        
        let sorted = mapped.sorted { $0.1 > $1.1 }
        return sorted
    }
    
    /// Category breakdown for a specific time period
    func totalsByCategory(
        from startDate: Date,
        to endDate: Date = .now
    ) -> [(categoryId: UUID, amount: Double)] {
        let filtered = realTransactions.filter {
            $0.date >= startDate && $0.date <= endDate
        }
        
        let grouped = Dictionary(grouping: filtered) { $0.categoryId }
        
        let mapped = grouped.map { categoryId, txs -> (UUID, Double) in
            let sum = txs.reduce(0) { $0 + abs($1.amount) }
            return (categoryId, sum)
        }
        
        let sorted = mapped.sorted { $0.1 > $1.1 }
        return sorted
    }
    
    /// Top N categories by spending
    func topCategories(
        limit: Int = 5,
        from startDate: Date? = nil,
        to endDate: Date = .now
    ) -> [(categoryId: UUID, amount: Double)] {
        let breakdown: [(UUID, Double)]
        
        if let start = startDate {
            breakdown = totalsByCategory(from: start, to: endDate)
        } else {
            breakdown = totalsByCategory()
        }
        
        return Array(breakdown.prefix(limit))
    }
    
    // MARK: - Trends & Comparisons
    
    /// Average daily spending for a period
    func averageDailySpending(
        from startDate: Date,
        to endDate: Date = .now
    ) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        let dayCount = components.day ?? 1
        
        guard dayCount > 0 else { return 0 }
        
        let totalAmount = total(from: startDate, to: endDate)
        let divisor = Double(max(dayCount, 1))
        return totalAmount / divisor
    }
    
    /// Compare this month vs last month
    func monthOverMonthChange() -> (current: Double, previous: Double, percentChange: Double) {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month], from: now)
        let thisMonthStart = calendar.date(from: components)!
        let lastMonthStart = calendar.date(byAdding: .month, value: -1, to: thisMonthStart)!
        
        let currentTotal = total(from: thisMonthStart, to: now)
        let previousTotal = total(from: lastMonthStart, to: thisMonthStart)
        
        let percentChange: Double
        if previousTotal > 0 {
            let difference = currentTotal - previousTotal
            percentChange = (difference / previousTotal) * 100
        } else {
            percentChange = 0
        }
        
        return (currentTotal, previousTotal, percentChange)
    }
    
    /// Compare this week vs last week
    func weekOverWeekChange() -> (current: Double, previous: Double, percentChange: Double) {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        let thisWeekStart = calendar.date(from: components)!
        let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: thisWeekStart)!
        
        let currentTotal = total(from: thisWeekStart, to: now)
        let previousTotal = total(from: lastWeekStart, to: thisWeekStart)
        
        let percentChange: Double
        if previousTotal > 0 {
            let difference = currentTotal - previousTotal
            percentChange = (difference / previousTotal) * 100
        } else {
            percentChange = 0
        }
        
        return (currentTotal, previousTotal, percentChange)
    }
    
    // MARK: - Statistics
    
    /// Transaction count for a period
    func transactionCount(
        from startDate: Date? = nil,
        to endDate: Date = .now
    ) -> Int {
        if let start = startDate {
            let filtered = realTransactions.filter {
                $0.date >= start && $0.date <= endDate
            }
            return filtered.count
        }
        return realTransactions.count
    }
    
    /// Average transaction amount
    func averageTransactionAmount(
        from startDate: Date? = nil,
        to endDate: Date = .now
    ) -> Double {
        let filtered: [Transaction]
        
        if let start = startDate {
            filtered = realTransactions.filter {
                $0.date >= start && $0.date <= endDate
            }
        } else {
            filtered = realTransactions
        }
        
        guard !filtered.isEmpty else { return 0 }
        
        let total = filtered.reduce(0) { $0 + abs($1.amount) }
        let count = Double(filtered.count)
        return total / count
    }
    
    /// Largest transaction in a period
    func largestTransaction(
        from startDate: Date? = nil,
        to endDate: Date = .now
    ) -> Transaction? {
        let filtered: [Transaction]
        
        if let start = startDate {
            filtered = realTransactions.filter {
                $0.date >= start && $0.date <= endDate
            }
        } else {
            filtered = realTransactions
        }
        
        return filtered.max { abs($0.amount) < abs($1.amount) }
    }
    
    // MARK: - Spending Patterns
    
    /// Day of week spending pattern (0 = Sunday, 6 = Saturday)
    func spendingByDayOfWeek() -> [(dayOfWeek: Int, amount: Double)] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: realTransactions) { tx -> Int in
            let weekday = calendar.component(.weekday, from: tx.date)
            return weekday - 1
        }
        
        let result = (0...6).map { day -> (Int, Double) in
            let txs = grouped[day] ?? []
            let amount = txs.reduce(0) { $0 + abs($1.amount) }
            return (day, amount)
        }
        
        return result
    }
    
    /// Category spending trend over months
    func categoryTrendMonthly(
        categoryId: UUID,
        months: Int = 6
    ) -> [(month: Date, amount: Double)] {
        let calendar = Calendar.current
        
        let categoryTxs = realTransactions.filter { $0.categoryId == categoryId }
        
        let grouped = Dictionary(grouping: categoryTxs) { tx -> Date in
            let components = calendar.dateComponents([.year, .month], from: tx.date)
            return calendar.date(from: components)!
        }
        
        let mapped = grouped.map { month, txs -> (Date, Double) in
            let sum = txs.reduce(0) { $0 + abs($1.amount) }
            return (month, sum)
        }
        
        let sorted = mapped.sorted { $0.0 < $1.0 }
        let recent = Array(sorted.suffix(months))
        return recent
    }
}
