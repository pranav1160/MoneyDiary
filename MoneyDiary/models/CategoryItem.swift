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
    let categoryType:CategoryType? = nil
    let period:CategoryPeriod? = nil
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
        categoryColor: .pink
    )
    
    static let utilities = CategoryItem(
        title: "Utilities",
        emoji: "💡",
        categoryColor: .pink
    )
    
    static let phoneBill = CategoryItem(
        title: "Phone Bill",
        emoji: "📱",
        categoryColor: .pink
    )
    
    static let internet = CategoryItem(
        title: "Internet",
        emoji: "🌐",
        categoryColor: .pink
    )
    
    static let insurance = CategoryItem(
        title: "Insurance",
        emoji: "🛡️",
        categoryColor: .pink
    )
    
    static let essentials: [CategoryItem] = [
        .rent,
        .utilities,
        .phoneBill,
        .internet,
        .insurance
    ]
    
    // MARK: - Food & Drink
    static let coffee = CategoryItem(
        title: "Coffee shops",
        emoji: "☕️",
        categoryColor: .orange
    )
    
    static let eatingOut = CategoryItem(
        title: "Eating out",
        emoji: "🍽️",
        categoryColor: .orange
    )
    
    static let groceries = CategoryItem(
        title: "Groceries",
        emoji: "🛒",
        categoryColor: .orange
    )
    
    static let foodAndDrink: [CategoryItem] = [
        .coffee,
        .eatingOut,
        .groceries
    ]
    
    // MARK: - Transportation
    static let gas = CategoryItem(
        title: "Gas",
        emoji: "⛽️",
        categoryColor: .purple
    )
    
    static let rides = CategoryItem(
        title: "Ubers / Lyft",
        emoji: "🚕",
        categoryColor: .purple
    )
    
    static let transportation: [CategoryItem] = [
        .gas,
        .rides
    ]
    
    
    // MARK: - Shopping
    static let clothes = CategoryItem(
        title: "Clothes",
        emoji: "👕",
        categoryColor: .blue
    )
    
    static let electronics = CategoryItem(
        title: "Electronics",
        emoji: "💻",
        categoryColor: .blue
    )
    
    static let onlineShopping = CategoryItem(
        title: "Online shopping",
        emoji: "📦",
        categoryColor: .blue
    )
    
    static let shopping: [CategoryItem] = [
        .clothes,
        .electronics,
        .onlineShopping
    ]

    // MARK: - Entertainment
    static let movies = CategoryItem(
        title: "Movies",
        emoji: "🎬",
        categoryColor: .red
    )
    
    static let games = CategoryItem(
        title: "Games",
        emoji: "🎮",
        categoryColor: .red
    )
    
    static let subscriptions = CategoryItem(
        title: "Subscriptions",
        emoji: "📺",
        categoryColor: .red
    )
    
    static let entertainment: [CategoryItem] = [
        .movies,
        .games,
        .subscriptions
    ]

    
    // MARK: - Health & Fitness
    static let gym = CategoryItem(
        title: "Gym",
        emoji: "🏋️",
        categoryColor: .green
    )
    
    static let medical = CategoryItem(
        title: "Medical",
        emoji: "💊",
        categoryColor: .green
    )
    
    static let wellness = CategoryItem(
        title: "Wellness",
        emoji: "🧘‍♂️",
        categoryColor: .green
    )
    
    static let health: [CategoryItem] = [
        .gym,
        .medical,
        .wellness
    ]

    
    // MARK: - Travel
    static let flights = CategoryItem(
        title: "Flights",
        emoji: "✈️",
        categoryColor: .brown
    )
    
    static let hotels = CategoryItem(
        title: "Hotels",
        emoji: "🏨",
        categoryColor: .green
    )
    
    static let localTravel = CategoryItem(
        title: "Local travel",
        emoji: "🚌",
        categoryColor: .black
    )
    
    static let travel: [CategoryItem] = [
        .flights,
        .hotels,
        .localTravel
    ]

    
    // MARK: - Personal
    static let gifts = CategoryItem(
        title: "Gifts",
        emoji: "🎁",
        categoryColor: .yellow
    )
    
    static let selfCare = CategoryItem(
        title: "Self care",
        emoji: "💆‍♂️",
        categoryColor: .yellow
    )
    
    static let hobbies = CategoryItem(
        title: "Hobbies",
        emoji: "🎨",
        categoryColor: .yellow
    )
    
    static let personal: [CategoryItem] = [
        .gifts,
        .selfCare,
        .hobbies
    ]

    // MARK: - Finance
    static let savings = CategoryItem(
        title: "Savings",
        emoji: "💰",
        categoryColor: .blue3
    )
    
    static let investments = CategoryItem(
        title: "Investments",
        emoji: "📈",
        categoryColor: .blue3
    )
    
    static let loans = CategoryItem(
        title: "Loans",
        emoji: "🏦",
        categoryColor: .pink2
    )
    
    static let finance: [CategoryItem] = [
        .savings,
        .investments,
        .loans
    ]

    
    
}
