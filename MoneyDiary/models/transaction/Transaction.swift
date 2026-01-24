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
        // Recent transactions (0-7 days ago)
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000001")!,
            title: "Eggs Purchase",
            amount: 100,
            daysAgo: 5,
            category: .eggs,
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
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000006")!,
                title: "Phone Bill Payment",
                amount: 599,
                daysAgo: 3,
                category: .phoneBill,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000007")!,
                title: "Internet Recharge",
                amount: 1299,
                daysAgo: 2,
                category: .internet,
                source: .manual
            ),
        
        // 1-2 weeks ago
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000008")!,
            title: "Building Blocks Set",
            amount: 1500,
            daysAgo: 8,
            category: .toys,
            source: .manual
        ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000009")!,
                title: "Fresh Eggs",
                amount: 180,
                daysAgo: 10,
                category: .eggs,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000010")!,
                title: "Water Bill",
                amount: 850,
                daysAgo: 12,
                category: .utilities,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000011")!,
                title: "WiFi Fiber Plan",
                amount: 999,
                daysAgo: 14,
                category: .internet,
                source: .manual
            ),
        
        // 2-3 weeks ago
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000012")!,
            title: "Puzzle Game",
            amount: 750,
            daysAgo: 16,
            category: .toys,
            source: .manual
        ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000013")!,
                title: "Gas Bill",
                amount: 1200,
                daysAgo: 18,
                category: .utilities,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000014")!,
                title: "Mobile Recharge",
                amount: 399,
                daysAgo: 19,
                category: .phoneBill,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000015")!,
                title: "Organic Eggs",
                amount: 250,
                daysAgo: 20,
                category: .eggs,
                source: .manual
            ),
        
            // 3-4 weeks ago
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000016")!,
                title: "Action Figure",
                amount: 899,
                daysAgo: 22,
                category: .toys,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000017")!,
                title: "Broadband Payment",
                amount: 1499,
                daysAgo: 25,
                category: .internet,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000018")!,
                title: "Maintenance Charges",
                amount: 3500,
                daysAgo: 27,
                category: .utilities,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000019")!,
                title: "Farm Eggs",
                amount: 200,
                daysAgo: 28,
                category: .eggs,
                source: .manual
            ),
        .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000021")!,
                title: "Postpaid Bill",
                amount: 649,
                daysAgo: 32,
                category: .phoneBill,
                source: .manual
            ),
        
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000022")!,
                title: "Toy Train Set",
                amount: 2500,
                daysAgo: 35,
                category: .toys,
                source: .manual
            ),
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000023")!,
                title: "Electricity Bill",
                amount: 2100,
                daysAgo: 36,
                category: .utilities,
                source: .manual
            ),
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000024")!,
            title: "Brown Eggs",
            amount: 190,
            daysAgo: 40,
            category: .eggs,
            source: .manual
        ),
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000025")!,
                title: "Fiber Internet",
                amount: 1299,
                daysAgo: 45,
                category: .internet,
                source: .manual
            ),
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000026")!,
                title: "Doll House",
                amount: 3200,
                daysAgo: 50,
                category: .toys,
                source: .manual
            ),
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000027")!,
                title: "Phone Plan",
                amount: 599,
                daysAgo: 55,
                category: .phoneBill,
                source: .manual
            ),
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000029")!,
                title: "Water + Gas",
                amount: 2050,
                daysAgo: 65,
                category: .utilities,
                source: .manual
            ),
            .mock(
                id: UUID(uuidString: "20000000-0000-0000-0000-000000000030")!,
                title: "Dozen Eggs",
                amount: 210,
                daysAgo: 70,
                category: .eggs,
                source: .manual
            ),
        
        // HOUSE RENT
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000002")!,
            title: "House Rent",
            amount: 24000,
            daysAgo: 1,
            category: .rent,
            source: .manual
        ),
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000020")!,
            title: "Monthly Rent",
            amount: 24000,
            daysAgo: 33,
            category: .rent,
            source: .manual
            ),
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000028")!,
            title: "House Rent",
            amount: 24000,
            daysAgo: 66,
            category: .rent,
            source: .manual
            ),
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000031")!,
            title: "Monthly Rent",
            amount: 31000,
            daysAgo: 99,
            category: .rent,
            source: .manual
        ),
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000032")!,
            title: "Monthly Rent",
            amount: 32000,
            daysAgo: 132,
            category: .rent,
            source: .manual
        ),
        .mock(
            id: UUID(uuidString: "20000000-0000-0000-0000-000000000033")!,
            title: "Monthly Rent",
            amount: 25000,
            daysAgo: 165,
            category: .rent,
            source: .manual
        )
    ]
    
    static let empty: [Transaction] = []
}

