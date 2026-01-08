//
//  Budget.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import Foundation
import Combine

// MARK: - Budget Model


struct Budget: Identifiable, Codable {
    let id: UUID
    let name: String
    let amount: Double
    let period: BudgetPeriod
    let categoryId: UUID
    let startDate: Date
    var isActive: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        amount: Double,
        period: BudgetPeriod,
        categoryId: UUID,
        startDate: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.period = period
        self.categoryId = categoryId
        self.startDate = startDate
        self.isActive = isActive
    }
}




enum BudgetPeriod: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}




// MARK: - Mock Data

extension Budget {
    static let mockBudgets: [Budget] = [
        Budget(
            name: "Monthly Groceries",
            amount: 500.0,
            period: .monthly,
            categoryId: Category.mockCategories[0].id
        ),
        Budget(
            name: "Total Monthly Budget",
            amount: 2000.0,
            period: .monthly,
            categoryId: Category.mockCategories[1].id
        ),
        Budget(
            name: "Weekly Entertainment",
            amount: 100.0,
            period: .weekly,
            categoryId: Category.mockCategories[3].id
        )
    ]
}
