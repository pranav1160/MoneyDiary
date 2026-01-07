//
//  CategoryItem.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//
import SwiftUI

struct CategoryItem: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let categoryColor: CategoryColor
    let categoryType:CategoryType
    let period:CategoryPeriod
}

enum CategoryType: String, CaseIterable {
    case expense = "Expense"
    case savings = "Savings"
}

enum CategoryPeriod: String, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
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
    case yellow2 = "CategoryYellow2"
    
    var id: String { rawValue }
    
    var color: Color {
        Color(rawValue)
    }
}

extension CategoryItem {
    
    // MARK: - Essentials
    static let rent = CategoryItem(
        title: "Rent",
        emoji: "🏠",
        categoryColor: .pink,
        categoryType: .expense,
        period: .monthly
    )
    
    static let utilities = CategoryItem(
        title: "Utilities",
        emoji: "💡",
        categoryColor: .pink,
        categoryType: .expense,
        period: .monthly
    )
    
    static let phoneBill = CategoryItem(
        title: "Phone Bill",
        emoji: "📱",
        categoryColor: .pink,
        categoryType: .expense,
        period: .monthly
    )
    
    static let internet = CategoryItem(
        title: "Internet",
        emoji: "🌐",
        categoryColor: .pink,
        categoryType: .expense,
        period: .monthly
    )
    
    static let insurance = CategoryItem(
        title: "Insurance",
        emoji: "🛡️",
        categoryColor: .pink,
        categoryType: .expense,
        period: .monthly
    )
    
    static let essentials: [CategoryItem] = [
        rent, utilities, phoneBill, internet, insurance
    ]
}



extension CategoryItem {
    
    // MARK: - Personal
    static let gifts = CategoryItem(
        title: "Gifts",
        emoji: "🎁",
        categoryColor: .yellow,
        categoryType: .expense,
        period: .monthly
    )
    
    static let selfCare = CategoryItem(
        title: "Self care",
        emoji: "💆‍♂️",
        categoryColor: .yellow,
        categoryType: .expense,
        period: .monthly
    )
    
    static let hobbies = CategoryItem(
        title: "Hobbies",
        emoji: "🎨",
        categoryColor: .yellow,
        categoryType: .expense,
        period: .monthly
    )
    
    static let personal: [CategoryItem] = [
        gifts, selfCare, hobbies
    ]
}


extension CategoryItem {
    
    // MARK: - Finance
    static let savings = CategoryItem(
        title: "Savings",
        emoji: "💰",
        categoryColor: .blue3,
        categoryType: .savings,
        period: .monthly
    )
    
    static let investments = CategoryItem(
        title: "Investments",
        emoji: "📈",
        categoryColor: .blue3,
        categoryType: .savings,
        period: .monthly
    )
    
    static let loans = CategoryItem(
        title: "Loans",
        emoji: "🏦",
        categoryColor: .pink2,
        categoryType: .expense,
        period: .monthly
    )
    
    static let finance: [CategoryItem] = [
        savings, investments, loans
    ]
}
