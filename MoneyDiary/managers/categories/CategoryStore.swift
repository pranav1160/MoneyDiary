//
//  CategoryStore.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

@MainActor
final class CategoryStore: ObservableObject {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func addCategory(_ category: Category) {
        context.insert(category)
        save()
    }
    
    func updateCategory(_ updated: Category) {
        save()
    }
    
    func deleteCategory(id: UUID) {
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.id == id }
        )
        
        if let category = try? context.fetch(descriptor).first {
            context.delete(category)
            save()
        }
    }
    
    func deleteCategory(_ category: Category) {
        deleteCategory(id: category.id)
    }
    
    
    
    func emoji(for categoryId: UUID?) -> String {
        guard let categoryId else { return "🅾️" }
        
        return fetchCategory(id: categoryId)?.emoji ?? "💰"
    }
    
    func color(for categoryId:UUID?) -> CategoryColor{
        guard let categoryId else { return .pink }
        
        return fetchCategory(id: categoryId)?.categoryColor ?? .green
    }
    
    func title(for categoryId: UUID?) -> String {
        guard let categoryId else { return "Uncategorized" }
        
        return fetchCategory(id: categoryId)?.title ?? "Uncategorized"
    }
    
    private func fetchCategory(id: UUID) -> Category? {
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }

    
    

    

    private func save() {
        try? context.save()
    }

}
