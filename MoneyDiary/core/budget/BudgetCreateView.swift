//
//  BudgetCreateView.swift
//  MoneyDiary
//
//  Created by Pranav on 09/01/26.
//


import SwiftUI

struct BudgetCreateView: View {

    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryStore: CategoryStore
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var selectedPeriod: BudgetPeriod = .monthly
    @State private var selectedCategoryId: UUID?
    @State private var isActive: Bool = true

    var body: some View {
        NavigationStack {
            Form {

                // MARK: - Budget Info
                Section("Budget Details") {
                    TextField("Budget name", text: $name)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(BudgetPeriod.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }

                // MARK: - Category
                Section("Category") {
                    Picker("Category", selection: $selectedCategoryId) {
                        Text("Select category").tag(UUID?.none)

                        ForEach(categoryStore.categories) { category in
                            Text("\(category.emoji) \(category.title)")
                                .tag(UUID?.some(category.id))
                        }
                    }
                }

                // MARK: - Status
                Section {
                    Toggle("Active", isOn: $isActive)
                }
            }
            .navigationTitle("New Budget")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        createBudget()
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

private extension BudgetCreateView {
    
    var isFormValid: Bool {
        !name.isEmpty &&
        Double(amount) != nil &&
        selectedCategoryId != nil
    }
    
    func createBudget() {
        guard
            let amount = Double(amount),
            let categoryId = selectedCategoryId
        else { return }
        
        let budget = Budget(
            name: name,
            amount: amount,
            period: selectedPeriod,
            categoryId: categoryId,
            isActive: isActive
        )
        
        budgetStore.addBudget(budget)
    }
}
