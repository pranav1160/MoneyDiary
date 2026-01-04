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
    let color: Color
}

extension CategoryItem {
    
    
    
    // MARK: - Essentials
    static let rent = CategoryItem(
        title: "Rent",
        emoji: "🏠",
        color: .pink
    )
    
    static let utilities = CategoryItem(
        title: "Utilities",
        emoji: "💡",
        color: .pink
    )
    
    static let phoneBill = CategoryItem(
        title: "Phone Bill",
        emoji: "📱",
        color: .pink
    )
    
    static let internet = CategoryItem(
        title: "Internet",
        emoji: "🌐",
        color: .pink
    )
    
    static let insurance = CategoryItem(
        title: "Insurance",
        emoji: "🛡️",
        color: .pink
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
        color: .orange
    )
    
    static let eatingOut = CategoryItem(
        title: "Eating out",
        emoji: "🍽️",
        color: .orange
    )
    
    static let groceries = CategoryItem(
        title: "Groceries",
        emoji: "🛒",
        color: .orange
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
        color: .purple
    )
    
    static let rides = CategoryItem(
        title: "Ubers / Lyft",
        emoji: "🚕",
        color: .purple
    )
    
    static let transportation: [CategoryItem] = [
        .gas,
        .rides
    ]
    
    
    // MARK: - Shopping
    static let clothes = CategoryItem(
        title: "Clothes",
        emoji: "👕",
        color: .blue
    )
    
    static let electronics = CategoryItem(
        title: "Electronics",
        emoji: "💻",
        color: .blue
    )
    
    static let onlineShopping = CategoryItem(
        title: "Online shopping",
        emoji: "📦",
        color: .blue
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
        color: .red
    )
    
    static let games = CategoryItem(
        title: "Games",
        emoji: "🎮",
        color: .red
    )
    
    static let subscriptions = CategoryItem(
        title: "Subscriptions",
        emoji: "📺",
        color: .red
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
        color: .green
    )
    
    static let medical = CategoryItem(
        title: "Medical",
        emoji: "💊",
        color: .green
    )
    
    static let wellness = CategoryItem(
        title: "Wellness",
        emoji: "🧘‍♂️",
        color: .green
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
        color: .teal
    )
    
    static let hotels = CategoryItem(
        title: "Hotels",
        emoji: "🏨",
        color: .teal
    )
    
    static let localTravel = CategoryItem(
        title: "Local travel",
        emoji: "🚌",
        color: .teal
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
        color: .yellow
    )
    
    static let selfCare = CategoryItem(
        title: "Self care",
        emoji: "💆‍♂️",
        color: .yellow
    )
    
    static let hobbies = CategoryItem(
        title: "Hobbies",
        emoji: "🎨",
        color: .yellow
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
        color: .mint
    )
    
    static let investments = CategoryItem(
        title: "Investments",
        emoji: "📈",
        color: .mint
    )
    
    static let loans = CategoryItem(
        title: "Loans",
        emoji: "🏦",
        color: .mint
    )
    
    static let finance: [CategoryItem] = [
        .savings,
        .investments,
        .loans
    ]

    
    
}
