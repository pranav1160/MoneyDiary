//
//  CategoryItem.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//
import SwiftUI

struct Category: Identifiable {
    let id : UUID
    let title: String
    let emoji: String
    let categoryColor: CategoryColor
}


enum CategoryColor: String, CaseIterable, Identifiable,ShapeStyle {
    case black = "CategoryBlack"
    
    case blue = "CategoryBlue"
    case blue2 = "CategoryBlue2"
    case blue3 = "CategoryBlue3"
    case blue4 = "CategoryBlue4"
    case blue5 = "CategoryBlue5"
    
    case brown = "CategoryBrown"
    
    case green = "CategoryGreen"
    case green2 = "CategoryGreen2"
    case green3 = "CategoryGreen3"
    
    case orange = "CategoryOrange"
    
    case pink = "CategoryPink"
    case pink2 = "CategoryPink2"
    
    case purple = "CategoryPurple"
    case purple2 = "CategoryPurple2"
    case purple3 = "CategoryPurple3"
    
    case red = "CategoryRed"
    case red1 = "CategoryRed1"
    case red2 = "CategoryRed2"
    
    case yellow = "CategoryYellow"
    var id: String { rawValue }
    
    var color: Color {
        Color(rawValue)
    }
}

extension Category {
    
    enum MockID {
        static let toys = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
        static let eggs = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        static let rent = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        static let utilities = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
        static let phoneBill = UUID(uuidString: "00000000-0000-0000-0000-000000000004")!
        static let internet = UUID(uuidString: "00000000-0000-0000-0000-000000000005")!
        static let savings = UUID(uuidString: "00000000-0000-0000-0000-000000000006")!
        static let investments = UUID(uuidString: "00000000-0000-0000-0000-000000000007")!
        static let salary = UUID(uuidString: "00000000-0000-0000-0000-000000000008")!
    }
    
    static let toys = Category(
        id: MockID.toys,
        title: "Toys",
        emoji: "🚂",
        categoryColor: .blue4
    )
    
    static let eggs = Category(
        id: MockID.eggs,
        title: "Eggs",
        emoji: "🥚",
        categoryColor: .red
    )
    
    static let rent = Category(
        id: MockID.rent,
        title: "Rent",
        emoji: "🏠",
        categoryColor: .pink
    )
    
    static let utilities = Category(
        id: MockID.utilities,
        title: "Utilities",
        emoji: "💡",
        categoryColor: .green
    )
    
    static let phoneBill = Category(
        id: MockID.phoneBill,
        title: "Phone Bill",
        emoji: "📱",
        categoryColor: .orange
    )
    
    static let internet = Category(
        id: MockID.internet,
        title: "Internet",
        emoji: "🌐",
        categoryColor: .yellow
    )
    
    static let mockCategories: [Category] = [
        eggs, rent, utilities, phoneBill, internet,toys
    ]
}
