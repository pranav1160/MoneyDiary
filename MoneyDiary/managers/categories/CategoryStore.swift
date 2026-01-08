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
    init(){
        loadMockCategories()
    }
    func addCategory(_ category: Category) {
        categories.insert(category, at: 0)
    }
    func loadMockCategories() {
        categories = Category.mockCategories
    }
}


