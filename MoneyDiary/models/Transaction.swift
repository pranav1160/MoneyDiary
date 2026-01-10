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
    
    static func mock(
        id: UUID,
        title: String,
        amount: Double,
        daysAgo: Int,
        type: TransactionType,
        recurring: Bool,
        category: Category
    ) -> Transaction {
        Transaction(
            id: id,
            title: title,
            amount: amount,
            date: .daysAgo(daysAgo),
            transactionType: type,
            isRecurring: recurring,
            categoryId: category.id
        )
    }
}


extension Transaction {
    
    static let mocks: [Transaction] = [
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000001")!,
                title: "Eggs Purchase",
                amount: 120,
                daysAgo: 3,
                type: .expense,
                recurring: false,
                category: .eggs
            ),

            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000002")!,
                title: "House Rent",
                amount: 24000,
                daysAgo: 1,
                type: .expense,
                recurring: true,
                category: .rent
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000003")!,
                title: "Electricity Bill",
                amount: 1800,
                daysAgo: 5,
                type: .expense,
                recurring: true,
                category: .utilities
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000004")!,
                title: "Salary",
                amount: 80000,
                daysAgo: 0,
                type: .income,
                recurring: true,
                category: .savings
            )
        
    ]
    
    static let empty: [Transaction] = []
}


extension Transaction {
    static let edgeCases: [Transaction] = [
        .mock(
            id: UUID(),
            title: "Zero Amount",
            amount: 0,
            daysAgo: 2,
            type: .expense,
            recurring: false,
            category: .eggs
        ),
        .mock(
            id: UUID(),
            title: "Future Transaction",
            amount: 500,
            daysAgo: -3,
            type: .expense,
            recurring: false,
            category: .rent
        )
    ]
}
