//
//  BudgetStore.swift
//  MoneyDiary
//
//  Created by Pranav on 09/01/26.
//
import Combine
import Foundation
import SwiftData


@MainActor
final class BudgetStore:ObservableObject {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func overallBudget() -> Budget? {
        let descriptor = FetchDescriptor<Budget>(
            predicate: #Predicate { $0.categoryId == nil }
        )
        return try? context.fetch(descriptor).first
    }


    func addBudget(_ budget: Budget) {
        // Enforce single overall budget
        if budget.categoryId == nil {
            deleteOverallBudget(except: budget.id)
        }
        
        context.insert(budget)
        save()
    }
    
    func updateBudget(_ budget: Budget) {
        if budget.categoryId == nil {
            deleteOverallBudget(except: budget.id)
        }
        
        // SwiftData tracks mutations automatically
        save()
    }
    
    func save(){
        try? context.save()
    }
    
    private func deleteOverallBudget(except id: UUID) {
        let descriptor = FetchDescriptor<Budget>(
            predicate: #Predicate {
                $0.categoryId == nil && $0.id != id
            }
        )
        
        let existing = (try? context.fetch(descriptor)) ?? []
        existing.forEach { context.delete($0) }
    }
    
    func deleteBudget(_ budget: Budget) {
        context.delete(budget)
        save()
    }



    func budgets(for categoryId: UUID) -> [Budget] {
        let descriptor = FetchDescriptor<Budget>(
            predicate: #Predicate { $0.categoryId == categoryId }
        )
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func categoryIdsWithBudgets() -> Set<UUID> {
        let descriptor = FetchDescriptor<Budget>(
            predicate: #Predicate { $0.categoryId != nil }
        )
        
        let budgets = (try? context.fetch(descriptor)) ?? []
        return Set(budgets.compactMap { $0.categoryId })
    }


}
