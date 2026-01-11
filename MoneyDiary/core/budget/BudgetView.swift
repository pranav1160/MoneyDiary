//
//  BudgetView.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import SwiftUI

struct BudgetView: View {
    @EnvironmentObject private var budgetManager: BudgetManager
    @EnvironmentObject private var categoryStore: CategoryStore
    
    var body: some View {
        VStack{
            List {
                Section("Budgets") {
                    ForEach(budgetManager.budgetStatuses, id: \.budget.id) { status in
                        if let category = categoryStore.categories.first(where: {
                            $0.id == status.budget.categoryId
                        }) {
                            BudgetRow(
                                budget: status.budget,
                                emoji: category.emoji,
                                status: status
                            )
                        }
                    }
                }
            }
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        BudgetCreateView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}



