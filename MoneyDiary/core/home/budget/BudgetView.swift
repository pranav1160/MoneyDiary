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
    
    @State private var editingBudget: Budget?

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
                        .contentShape(Rectangle())   // makes whole row tappable
                        .onTapGesture {
                            editingBudget = status.budget
                        }
                    }
                }
            }
            .sheet(item: $editingBudget) { budget in
                BudgetFormView(
                    mode: budget.categoryId == nil ? .overall : .category,
                    purpose: .edit(budget)
                )
            }
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        BudgetFormView(
                            mode: .category,
                            purpose: .create
                        )

                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        BudgetFormView(
                            mode: .overall,
                            purpose: .create
                        )

                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}



