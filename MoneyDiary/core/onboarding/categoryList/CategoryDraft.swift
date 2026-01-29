//
//  CategoryDraft.swift
//  MoneyDiary
//
//  Created by Pranav on 29/01/26.
//

import Foundation

struct CategoryDraft: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let color: CategoryColor
}

enum OnboardingCategories {
    static let all: [CategoryDraft] = essentials + lifestyle  + financial  + other
    
    // MARK: - Essentials
    static let essentials: [CategoryDraft] = [
        .init(title: "Groceries", emoji: "🛒", color: .green),
        .init(title: "Dining Out", emoji: "🍽️", color: .red),
        .init(title: "Rent", emoji: "🏠", color: .blue),
        .init(title: "Utilities", emoji: "💡", color: .yellow),
        .init(title: "Transport", emoji: "🚗", color: .orange)
    ]

    
    // MARK: - Lifestyle & Shopping
    static let lifestyle: [CategoryDraft] = [
        .init(title: "Shopping", emoji: "🛍️", color: .pink),
        .init(title: "Health", emoji: "🏥", color: .red),
        .init(title: "Fitness", emoji: "🏋️", color: .green),
        .init(title: "Entertainment", emoji: "🎬", color: .purple)
    ]

    
   
    
    // MARK: - Financial & Bills
    static let financial: [CategoryDraft] = [
        .init(title: "Bills", emoji: "📄", color: .blue),
        .init(title: "Subscriptions", emoji: "📺", color: .purple),
        .init(title: "Insurance", emoji: "🛡️", color: .blue2)
    ]

    
  
   
    
    // MARK: - Other
    static let other: [CategoryDraft] = [
        .init(title: "Travel", emoji: "✈️", color: .blue3),
        .init(title: "Gifts", emoji: "🎁", color: .pink2),
        .init(title: "Other", emoji: "📦", color: .green2)
    ]

}

