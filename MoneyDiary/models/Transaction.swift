//
//  Expense.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation

struct Transaction: Identifiable {
    let id: UUID
    let title: String
    let amount: Double
    let date: Date
    let transactionType: TransactionType
    let isRecurring: Bool
    let categoryId: UUID
}


enum TransactionType:String, CaseIterable{
    case expense = "Expense"
    case income = "Income"
}

extension Transaction {
    
    static let transactionMocks: [Transaction] = {
        
        let categories = Category.mockCategories
        let expenseCategories = categories.filter { $0.categoryType == .expense }
        let savingsCategories = categories.filter { $0.categoryType == .savings }
        
        return [
            // MARK: - Expenses
            Transaction(
                id: UUID(),
                title: "House Rent",
                amount: 12000,
                date: Date().daysAgo(2),
                transactionType: .expense,
                isRecurring: true,
                categoryId: expenseCategories.first { $0.title == "Rent" }!.id
            ),
            
            Transaction(
                id: UUID(),
                title: "Electricity Bill",
                amount: 1800,
                date: Date().daysAgo(5),
                transactionType: .expense,
                isRecurring: true,
                categoryId: expenseCategories.first { $0.title == "Utilities" }!.id
            ),
            
            Transaction(
                id: UUID(),
                title: "Mobile Recharge",
                amount: 699,
                date: Date().daysAgo(7),
                transactionType: .expense,
                isRecurring: true,
                categoryId: expenseCategories.first { $0.title == "Phone Bill" }!.id
            ),
            
            Transaction(
                id: UUID(),
                title: "Netflix Subscription",
                amount: 499,
                date: Date().daysAgo(10),
                transactionType: .expense,
                isRecurring: true,
                categoryId: expenseCategories.first { $0.title == "Internet" }!.id
            ),
            
            // MARK: - Personal
            Transaction(
                id: UUID(),
                title: "Gym Membership",
                amount: 1500,
                date: Date().daysAgo(3),
                transactionType: .expense,
                isRecurring: true,
                categoryId: expenseCategories.first { $0.title == "Self care" }!.id
            ),
            
            Transaction(
                id: UUID(),
                title: "Painting Supplies",
                amount: 850,
                date: Date().daysAgo(12),
                transactionType: .expense,
                isRecurring: false,
                categoryId: expenseCategories.first { $0.title == "Hobbies" }!.id
            ),
            
            // MARK: - Savings
            Transaction(
                id: UUID(),
                title: "Monthly Savings",
                amount: 5000,
                date: Date().daysAgo(1),
                transactionType: .income,
                isRecurring: true,
                categoryId: savingsCategories.first { $0.title == "Savings" }!.id
            ),
            
            Transaction(
                id: UUID(),
                title: "Mutual Fund SIP",
                amount: 3000,
                date: Date().daysAgo(6),
                transactionType: .income,
                isRecurring: true,
                categoryId: savingsCategories.first { $0.title == "Investments" }!.id
            )
        ]
    }()
}
