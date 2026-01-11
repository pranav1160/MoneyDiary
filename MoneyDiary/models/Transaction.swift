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
    let isRecurring: Bool
    let categoryId: UUID
}



extension Transaction {
    
    static func mock(
        id: UUID,
        title: String,
        amount: Double,
        daysAgo: Int,
        recurring: Bool,
        category: Category
    ) -> Transaction {
        Transaction(
            id: id,
            title: title,
            amount: amount,
            date: .daysAgo(daysAgo),
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
                recurring: false,
                category: .eggs
            ),

            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000002")!,
                title: "House Rent",
                amount: 24000,
                daysAgo: 1,
                recurring: true,
                category: .rent
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000003")!,
                title: "Electricity Bill",
                amount: 1800,
                daysAgo: 5,
                recurring: true,
                category: .utilities
            )
        
    ]
    
    static let empty: [Transaction] = []
}


