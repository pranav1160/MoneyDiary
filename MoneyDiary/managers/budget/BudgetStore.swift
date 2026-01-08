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
    
    init() {
        loadMocks()
    }

    func addBudget(_ budget: Budget) {
        budgets.append(budget)
    }

    func budgets(for categoryId: UUID) -> [Budget] {
        budgets.filter { $0.categoryId == categoryId }
    }
    
    
    func loadMocks(){
        budgets = Budget.mockBudgets
    }
}
