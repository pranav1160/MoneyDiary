//
//  CategoryStore.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//

import Foundation
import Combine

@MainActor
final class CategoryStore: ObservableObject {
    @Published private(set) var categories: [Category] = []
    
    init() {
        loadMockCategories()
    }
    
    func addCategory(_ category: Category) {
        categories.insert(category, at: 0)
    }
    
    func updateCategory(_ updated: Category) {
        guard let index = categories.firstIndex(where: { $0.id == updated.id }) else { return }
        categories[index] = updated
    }
    
    func loadMockCategories() {
        categories = Category.mockCategories
    }
    
    func emoji(for categoryId: UUID?) -> String {
        guard let categoryId else {
            return "🅾️"   // overall budget emoji
        }
        return categories.first { $0.id == categoryId }?.emoji ?? "💰"
    }

}
