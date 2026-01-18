//
//  Expense.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation

struct Transaction: Identifiable {
    let id: UUID
    let title: String?
    let amount: Double
    let date: Date
    let categoryId: UUID
    let recurrenceInfo: RecurrenceInfo?
    let source: TransactionSource
    
    init(
        id: UUID,
        title: String?,
        amount: Double,
        date: Date,
        categoryId: UUID,
        recurrenceInfo: RecurrenceInfo? = nil,
        source:TransactionSource
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.categoryId = categoryId
        self.recurrenceInfo = recurrenceInfo
        self.source = source
    }
}

extension Transaction {
    func displayTitle(using categories: [Category]) -> String {
        if let title, !title.trimmingCharacters(in: .whitespaces).isEmpty {
            return title
        }
        
        return categories.first(where: { $0.id == categoryId })?.title
        ?? "Transaction"
    }
}


extension Transaction {
    
    static func mock(
        id: UUID,
        title: String,
        amount: Double,
        daysAgo: Int,
        
        category: Category,
        source:TransactionSource
    ) -> Transaction {
        Transaction(
            id: id,
            title: title,
            amount: amount,
            date: .daysAgo(daysAgo),
            categoryId: category.id,
            source: source
        )
    }
}


extension Transaction {
    
    static let mocks: [Transaction] = [
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000001")!,
                title: "Eggs Purchase",
                amount: 100,
                daysAgo: 5,
                category: .eggs,
                source: .manual
            ),
            
            

            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000002")!,
                title: "House Rent",
                amount: 24000,
                daysAgo: 1,
                category: .rent,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000003")!,
                title: "Electricity Bill",
                amount: 2000,
                daysAgo: 5,
                category: .utilities,
                source: .manual
            ),
            
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000004")!,
                title: "Robo car",
                amount: 2000,
                daysAgo: 1,
                category: .toys,
                source: .manual
            ),
            
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000005")!,
                title: "Ande liye",
                amount: 220,
                daysAgo: 1,
                category: .eggs,
                source: .manual
            )
        
    ]
    
    static let empty: [Transaction] = []
}


