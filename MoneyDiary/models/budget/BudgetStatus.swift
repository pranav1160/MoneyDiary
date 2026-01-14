//
//  BudgetStatus.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import Foundation
// MARK: - Budget Status

struct BudgetStatus {
    let budget: Budget
    let spent: Double
    let percentageUsed: Double
    let isOverBudget: Bool
    let daysRemaining: Int
    
    var remaining:Double{
        return budget.amount - spent
    }
    
    var status: Status {
        if isOverBudget { return .overBudget }
        if percentageUsed >= 90 { return .warning }
        if percentageUsed >= 75 { return .caution }
        return .healthy
    }
    
    enum Status {
        case healthy
        case caution
        case warning
        case overBudget
    }
}

extension BudgetStatus {
    
    static let mockHealthy = BudgetStatus(
        budget: Budget(
            name: "Groceries",
            amount: 500,
            period: .monthly,
            categoryId: UUID()
        ),
        spent: 120,
        percentageUsed: 24,
        isOverBudget: false,
        daysRemaining: 18
    )
    
    static let mockCaution = BudgetStatus(
        budget: Budget(
            name: "Entertainment",
            amount: 200,
            period: .monthly,
            categoryId: UUID()
        ),
        spent: 160,
        percentageUsed: 80,
        isOverBudget: false,
        daysRemaining: 10
    )
    
    static let mockWarning = BudgetStatus(
        budget: Budget(
            name: "Dining Out",
            amount: 300,
            period: .monthly,
            categoryId: UUID()
        ),
        spent: 280,
        percentageUsed: 93,
        isOverBudget: false,
        daysRemaining: 5
    )
    
    static let mockOverBudget = BudgetStatus(
        budget: Budget(
            name: "Shopping",
            amount: 400,
            period: .monthly,
            categoryId: UUID()
        ),
        spent: 520,
        percentageUsed: 130,
        isOverBudget: true,
        daysRemaining: 12
    )
    
    static let mockAll: [BudgetStatus] = [
        mockHealthy,
        mockCaution,
        mockWarning,
        mockOverBudget
    ]
}

