//
//  BudgetCalculator.swift
//  MoneyDiary
//
//  Created by Pranav on 09/01/26.
//

import Foundation
import Combine

// MARK: - BudgetCalculator

struct BudgetCalculator {

    func transactions(
        for budget: Budget,
        from transactions: [Transaction],
        now: Date = Date()
    ) -> [Transaction] {

        let startDate = periodStartDate(
            period: budget.period,
            referenceDate: now
        )

        return transactions
            .filter { $0.recurrenceInfo == nil }
            .filter { transaction in
                if budget.categoryId == nil {
                    transaction.date >= startDate
                } else {
                    transaction.categoryId == budget.categoryId &&
                    transaction.date >= startDate
                }
            }

    }

    func spentAmount(
        for budget: Budget,
        transactions: [Transaction]
    ) -> Double {
        
        transactions
            .reduce(0) { $0 + abs($1.amount) }
    }
}

extension BudgetCalculator {
    
    func periodStartDate(
        period: BudgetPeriod,
        referenceDate: Date
    ) -> Date {
        
        let calendar = Calendar.current
        
        switch period {
        case .daily:
            return calendar.startOfDay(for: referenceDate)
            
        case .weekly:
            return calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: referenceDate
                )
            )!
            
        case .monthly:
            return calendar.date(
                from: calendar.dateComponents(
                    [.year, .month],
                    from: referenceDate
                )
            )!
            
        case .yearly:
            return calendar.date(
                from: calendar.dateComponents(
                    [.year],
                    from: referenceDate
                )
            )!
        }
    }
}

extension BudgetCalculator {
    
    func status(
        for budget: Budget,
        allTransactions: [Transaction],
        now: Date = Date()
    ) -> BudgetStatus {
        
        
        
        // 1️⃣ Relevant transactions
        let relevantTransactions = transactions(
            for: budget,
            from: allTransactions,
            now: now
        )
        
        // 2️⃣ Spent amount
        let spent = spentAmount(
            for: budget,
            transactions: relevantTransactions
        )
        
        
        
        // 4️⃣ Percentage used (0–100)
        let percentageUsed = budget.amount == 0
        ? 0
        : (spent / budget.amount) * 100
        
        // 5️⃣ Over budget
        let isOverBudget = spent > budget.amount
        
        // 6️⃣ Days remaining
        let daysRemaining = remainingDays(
            for: budget,
            now: now
        )
        
        return BudgetStatus(
            budget: budget,
            spent: spent,
            percentageUsed: percentageUsed,
            isOverBudget: isOverBudget,
            daysRemaining: daysRemaining
        )
    }
}


extension BudgetCalculator {
    
    func remainingDays(
        for budget: Budget,
        now: Date
    ) -> Int {
        
        let calendar = Calendar.current
        
        let endDate: Date
        
        switch budget.period {
        case .daily:
            endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))!
            
        case .weekly:
            endDate = calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: now
                )
            )!.addingTimeInterval(7 * 24 * 60 * 60)
            
        case .monthly:
            endDate = calendar.date(
                byAdding: .month,
                value: 1,
                to: calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            )!
            
        case .yearly:
            endDate = calendar.date(
                byAdding: .year,
                value: 1,
                to: calendar.date(from: calendar.dateComponents([.year], from: now))!
            )!
        }
        
        return max(
            calendar.dateComponents([.day], from: now, to: endDate).day ?? 0,
            0
        )
    }
}
