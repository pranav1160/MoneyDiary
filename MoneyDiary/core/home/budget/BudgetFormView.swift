//
//  BudgetCreateView.swift
//  MoneyDiary
//
//  Created by Pranav on 09/01/26.
//


import SwiftUI

struct BudgetFormView: View {

    @EnvironmentObject private var budgetStore: BudgetStore
    @EnvironmentObject private var categoryStore: CategoryStore
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var selectedPeriod: BudgetPeriod = .monthly
    @State private var selectedCategoryId: UUID?
    @State private var isActive: Bool = true
    let mode:BudgetFormMode
    let purpose: BudgetFormPurpose
    
    var existingId: UUID {
        if case .edit(let budget) = purpose {
            return budget.id
        }
        return UUID()
    }
    
    var actionTitle: String {
        switch purpose {
        case .create: return "Save"
        case .edit: return "Update"
        }
    }
    
    init(
        mode: BudgetFormMode,
        purpose: BudgetFormPurpose
    ) {
        self.mode = mode
        self.purpose = purpose
        
        switch purpose {
        case .create:
            _name = State(initialValue: "")
            _amount = State(initialValue: "")
            _selectedPeriod = State(initialValue: .monthly)
            _selectedCategoryId = State(initialValue: nil)
            _isActive = State(initialValue: true)
            
        case .edit(let budget):
            _name = State(initialValue: budget.name)
            _amount = State(initialValue: String(budget.amount))
            _selectedPeriod = State(initialValue: budget.period)
            _selectedCategoryId = State(initialValue: budget.categoryId)
            _isActive = State(initialValue: budget.isActive)
        }
    }


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

                if mode == .category{
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
                    Button(actionTitle) {
                        saveBudget()
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

private extension BudgetFormView {
    
    var isFormValid: Bool {
        !name.isEmpty &&
        Double(amount) != nil &&
        (mode == .overall || selectedCategoryId != nil)
    }
    
    func saveBudget() {
        guard let amount = Double(amount) else { return }
        
        let budget = Budget(
            id: existingId,
            name: name,
            amount: amount,
            period: selectedPeriod,
            categoryId: mode == .overall ? nil : selectedCategoryId,
            isActive: isActive
        )
        
        switch purpose {
        case .create:
            budgetStore.addBudget(budget)
            
        case .edit:
            budgetStore.updateBudget(budget)
        }
    }

}
