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
    @Published private(set) var categories: [CategoryItem] = []

    func addCategory(_ category: CategoryItem) {
        categories.append(category)
    }
}
