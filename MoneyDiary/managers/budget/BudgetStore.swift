//
//  BudgetStore.swift
//  MoneyDiary
//
//  Created by Pranav on 09/01/26.
//
import Combine
import Foundation


@MainActor
final class BudgetStore: ObservableObject {
    @Published private(set) var budgets: [Budget] = []
    
    var overallBudget: Budget? {
        budgets.first { $0.categoryId == nil }
    }

    
    init() {
        loadMocks()
    }

    func addBudget(_ budget: Budget) {
        if budget.categoryId == nil{
            // Remove existing overall budget (if any)
            budgets.removeAll { $0.categoryId == nil }
        }
        budgets.append(budget)
    }
    
    func updateBudget(_ updated: Budget) {
        // If editing overall budget, ensure uniqueness
        if updated.categoryId == nil {
            budgets.removeAll { $0.categoryId == nil && $0.id != updated.id }
        }
        
        // Single update operation
        if let index = budgets.firstIndex(where: { $0.id == updated.id }) {
            budgets[index] = updated
        } else {
            budgets.append(updated)
        }
    }
    
    func deleteBudget(id: UUID) {
        budgets.removeAll { $0.id == id }
    }



    func budgets(for categoryId: UUID) -> [Budget] {
        budgets.filter { $0.categoryId == categoryId }
    }
    
    
    func loadMocks(){
        budgets = Budget.mockBudgets
    }
}
