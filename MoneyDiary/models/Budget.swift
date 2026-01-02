//
//  Budget.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation

struct Budget: Identifiable {
    let id: UUID
    let categoryId: UUID
    let limit: Double
    let period: BudgetPeriod
}

enum BudgetPeriod {
    case weekly, monthly , yearly
}
