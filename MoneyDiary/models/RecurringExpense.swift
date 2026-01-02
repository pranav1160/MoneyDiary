//
//  RecurringExpense.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation

struct RecurringExpense: Identifiable {
    let id: UUID
    let expenseTemplate: Expense
    let frequency: RecurringFrequency
}

enum RecurringFrequency {
    case daily, weekly, monthly
}


extension RecurringExpense {
    static let mockRecurringExpenses: [RecurringExpense] = [
        RecurringExpense(
            id: UUID(),
            expenseTemplate: Expense(
                id: UUID(),
                title: "Morning Coffee",
                amount: 150,
                date: Date(),
                categoryId: UUID(),
                accountId: UUID(),
                isRecurring: true
            ),
            frequency: .daily
        ),
        
        RecurringExpense(
            id: UUID(),
            expenseTemplate: Expense(
                id: UUID(),
                title: "Gym Membership",
                amount: 1200,
                date: Date(),
                categoryId: UUID(),
                accountId: UUID(),
                isRecurring: false
            ),
            frequency: .monthly
        ),
        
        RecurringExpense(
            id: UUID(),
            expenseTemplate: Expense(
                id: UUID(),
                title: "Netflix Subscription",
                amount: 499,
                date: Date(),
                categoryId: UUID(),
                accountId: UUID(),
                isRecurring: false
            ),
            frequency: .monthly
        )
    ]
}
