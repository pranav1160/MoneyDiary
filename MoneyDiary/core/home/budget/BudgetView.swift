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
                            BudgetRow(
                                budget: status.budget,
                                emoji: categoryStore.emoji(for: status.budget.categoryId),
                                status: status
                            )
                    }
                }
            }
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        BudgetFormView(mode: .category)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        BudgetFormView(mode: .overall)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}



