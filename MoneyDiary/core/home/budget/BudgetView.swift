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
    @EnvironmentObject private var currencyManager: CurrencyManager
    
    @State private var editingBudget: Budget?

    private var glass:some View{
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: [
                        .white.opacity(0.35),
                        .white.opacity(0.05),
                        .white.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
    
    }
    
    private var overallBudgetSection:some View{
        VStack{
            if let overallStatus = budgetManager.budgetStatuses
                .first(where: { $0.budget.categoryId == nil }) {
                
                BudgetOverallRow(
                    currencySymbol: currencyManager.selectedCurrency.symbol,
                    status: overallStatus
                )
                .frame(maxWidth: .infinity,alignment: .center)
                
            }
        }
    }
    
    private var categoriesSection:some View{
        ScrollView {
            ForEach(
                budgetManager.budgetStatuses
                    .filter { $0.budget.categoryId != nil },
                id: \.budget.id
            ) { status in
                BudgetCategoryRow(
                    currencySymbol: currencyManager.selectedCurrency.symbol,
                    budget: status.budget,
                    emoji: categoryStore.emoji(for: status.budget.categoryId),
                    status: status,
                    statusBarColor: categoryStore.color(for: status.budget.categoryId)
                )
                .contentShape(Rectangle())
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
                .overlay {
                    glass
                }
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                .onTapGesture {
                    editingBudget = status.budget
                }
                
            }
            .padding(.vertical, 8)
            
        }
    }
    
    var body: some View {
        VStack{
         
            overallBudgetSection
            categoriesSection
            
            .sheet(item: $editingBudget) { budget in
                BudgetFormView(
                    mode: budget.categoryId == nil ? .overall : .category,
                    purpose: .edit(budget)
                )
            }
            .navigationTitle("Budgets")
            .navigationBarTitleDisplayMode(.inline)
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

