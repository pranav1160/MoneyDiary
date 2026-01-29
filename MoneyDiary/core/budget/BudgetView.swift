//
//  BudgetView.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import SwiftUI
import SwiftData

struct BudgetView: View {
    @EnvironmentObject private var budgetManager: BudgetManager
    @EnvironmentObject private var categoryStore: CategoryStore
   

    
    @Query(sort: \Category.title) var categories: [Category]

    @EnvironmentObject private var currencyManager: CurrencyManager
    @EnvironmentObject private var toastManager: ToastManager
    
    @State private var editingBudget: Budget?

    var body: some View {
        VStack{
            header
            overallBudgetSection
            categoriesSection
            
        }
        .sheet(item: $editingBudget) { budget in
            BudgetFormView(
                mode: budget.categoryId == nil ? .overall : .category,
                purpose: .edit(budget),
                onFinish: { result in
                    switch result {
                    case .created:
                        break
                    case .updated:
                        toastManager.show(.success("Toast Updated"))
                    case .deleted:
                        toastManager.show(.success("Toast Deleted"))
                    }
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View{
        CustomNavigationHeader(
            title: "Budgets",
            showsBackButton: false) {
                NavigationLink {
                    BudgetFormView(
                        mode: .category,
                        purpose: .create,
                        onFinish: {result in
                            switch result {
                            case .created:
                                toastManager.show(.success("Budget Added"))
                            case .updated:
                                break
                            case .deleted:
                                break
                            }
                        }
                    )
                } label: {
                    Image(systemName: "plus.capsule.fill")
                        .font(.title)
                }
            }
    }
    
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
                .overlay(alignment: .bottomTrailing) {
                    NavigationLink {
                        BudgetFormView(
                            mode: .overall,
                            purpose:
                                    .edit(overallStatus.budget),
                            onFinish: {
                                result in
                                switch result {
                                case .created:
                                    break
                                case .updated:
                                    toastManager.show(.success("Overall Budget updated"))
                                case .deleted:
                                    toastManager.show(.success("Overall Budget Deleted"))
                                }
                            }
                        )
                    } label: {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(Circle().fill(.black.opacity(0.6)))
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 36)
                    .padding(.bottom, 56)
                }
            }
            else{
                VStack{
                    //urge the user to add an overall budget
                    NavigationLink {
                        BudgetFormView(
                            mode: .overall,
                            purpose: .create, onFinish: {result in
                                switch result {
                                case .created:
                                    toastManager.show(.success("Overall Budget Added"))
                                case .updated:
                                    break
                                case .deleted:
                                    break
                                }
                            }
                        )
                    } label: {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(Circle().fill(.black.opacity(0.6)))
                            .shadow(radius: 4)
                    }
                    
                    Text("Please Add an overall Budget")
                }
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
                    statusBarColor: categoryStore
                        .color(for: status.budget.categoryId),
                    title: status.budget.displayName(using: categories)
                )
                .contentShape(Rectangle())
                .padding(10)
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
    

}


#Preview {
    NavigationStack{
        let container = {
            let preview = Preview(Category.self)
            preview.addSamples(Category.mockCategories)
            return preview.container
        }()
        BudgetView()
            .withPreviewEnvironment(container: container)
    }
}
