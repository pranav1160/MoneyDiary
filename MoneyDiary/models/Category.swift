//
//  Category.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation
import SwiftUI

struct Category: Identifiable {
    let id: UUID
    let name: String
    let icon: String
    let color: Color
}


extension Category {
    static let mockCategories: [Category] = [
        Category(
            id: UUID(),
            name: "Bills",
            icon: "doc.text",
            color: .blue
        ),
        Category(
            id: UUID(),
            name: "Rent",
            icon: "house.fill",
            color: .purple
        ),
        Category(
            id: UUID(),
            name: "Travel",
            icon: "airplane",
            color: .teal
        ),
        Category(
            id: UUID(),
            name: "Transport",
            icon: "car.fill",
            color: .green
        ),
        Category(
            id: UUID(),
            name: "Shopping",
            icon: "bag.fill",
            color: .cyan
        ),
        Category(
            id: UUID(),
            name: "Entertainment",
            icon: "gamecontroller.fill",
            color: .indigo
        ),
        Category(
            id: UUID(),
            name: "Health",
            icon: "cross.fill",
            color: .mint
        ),
        Category(
            id: UUID(),
            name: "Education",
            icon: "graduationcap.fill",
            color: .yellow
        ),
        Category(
            id: UUID(),
            name: "Utilities",
            icon: "lightbulb.fill",
            color: .orange
        )
    ]
}
