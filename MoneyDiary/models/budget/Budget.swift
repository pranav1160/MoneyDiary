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
    let name: String?
    let amount: Double
    let period: BudgetPeriod
    let categoryId: UUID?
    let startDate: Date
    var isActive: Bool
    
    init(
        id: UUID = UUID(),
        name: String? = nil,
        amount: Double,
        period: BudgetPeriod,
        categoryId: UUID? = nil,
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

extension Budget {
    func displayName(using categories: [Category]) -> String {
        // 1️⃣ Explicit name wins
        if let name, !name.trimmingCharacters(in: .whitespaces).isEmpty {
            return name
        }
        
        // 2️⃣ Category-based budget
        if let categoryId,
           let category = categories.first(where: { $0.id == categoryId }) {
            return category.title
        }
        
        // 3️⃣ No category → Overall
        return "Overall"
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
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000001")!,
            name: "Monthly Groceries",
            amount: 5000,
            period: .monthly,
            categoryId: Category.eggs.id
        ),
        Budget(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000002")!,
            name: "House Rent",
            amount: 25000,
            period: .monthly,
            categoryId: Category.rent.id
        ),
        Budget(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000003")!,
            name: "Electricity",
            amount: 5000,
            period: .monthly,
            categoryId: Category.utilities.id
        ),
        Budget(
            id: UUID(uuidString: "10000000-0000-0000-0000-000000000004")!,
            name: "Overall",
            amount: 50000,
            period: .monthly,
            categoryId: nil
        )
        
    ]
    
    static let empty: [Budget] = []
}
