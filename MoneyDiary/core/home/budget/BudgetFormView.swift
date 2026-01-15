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
    @State private var isDeletePressed = false

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var selectedPeriod: BudgetPeriod = .monthly
    @State private var selectedCategoryId: UUID?
    @State private var isActive: Bool = true
    @State private var showDeleteConfirmation = false
    @State private var appAlert: AnyAppAlert?

    let mode:BudgetFormMode
    let purpose: BudgetFormPurpose
    
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
            VStack{
                CustomNavigationHeader(
                    title: navigationTitle,
                    showsBackButton: true) {
                        ToolBarCapsuleButton(
                            title: actionTitle
                        ) {
                            onSavePressed()
                        }

                    }
                Form {
                    // MARK: - Budget Info
                    budgetInfoSection
                    
                    if mode == .category{
                        budgetCategorySection
                    }
                    
                    // MARK: - Status
                    budgetStatusSection
                    
                    // MARK: - Delete the budget
                    if case .edit = purpose {
                        budgetDeleteSection
                    }
                    
                }
            }
            .hideSystemNavigation()
            .showCustomAlert(
                type: .alert,
                alert: $appAlert
            )

            .confirmationDialog(
                "Delete this budget?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete Budget", role: .destructive) {
                    deleteBudget()
                    dismiss()
                }
                
                Button("Cancel", role: .cancel) {}
            }
            
        }
    }
    
    var navigationTitle: String {
        switch purpose {
        case .create:
            return "Add Budget"
        case .edit:
            return "Edit Budget"
        }
    }

    
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
    
  
    private var budgetInfoSection:some View{
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
    }
    
    private var budgetCategorySection:some View{
            
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
    
    private var budgetStatusSection:some View{
        Section {
            Toggle("Active", isOn: $isActive)
        }
    }
    
    private var budgetDeleteSection:some View{
      
            Section {
                Button(role: .destructive) {
                    withAnimation(.easeOut(duration: 0.15)) {
                        isDeletePressed = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        isDeletePressed = false
                        showDeleteConfirmation = true
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "trash")
                        
                        Text("Delete Budget")
                    }
                    .font(.title3)
                    .scaleEffect(isDeletePressed ? 0.96 : 1)
                    .opacity(isDeletePressed ? 0.7 : 1)
                    .animation(.easeOut(duration: 0.15), value: isDeletePressed)
                }
            }
        
    }


    
}

private extension BudgetFormView {
    
    func deleteBudget() {
        if case .edit(let budget) = purpose {
            budgetStore.deleteBudget(id: budget.id)
        }
    }

    
    var isFormValid: Bool {
        !name.isEmpty &&
        Double(amount) != nil &&
        (mode == .overall || selectedCategoryId != nil)
    }
    
    private func onSavePressed() {
        // Category required but not selected
        if mode == .category && selectedCategoryId == nil {
            showCategoryRequiredAlert()
            return
        }
        
        // Amount invalid
        guard Double(amount) != nil else {
            showInvalidAmountAlert()
            return
        }
        
        // Name empty
        guard !name.isEmpty else {
            showNameRequiredAlert()
            return
        }
        
        saveBudget()
        dismiss()
    }

    private func showCategoryRequiredAlert() {
        appAlert = AnyAppAlert(
            alertTitle: "Category Required",
            alertSubtitle: "Please select a category to continue."
        ) {
            AnyView(
                Button("OK", role: .cancel) { }
            )
        }
    }

    private func showInvalidAmountAlert() {
        appAlert = AnyAppAlert(
            alertTitle: "Invalid Amount",
            alertSubtitle: "Please enter a valid number."
        )
    }

    
    private func showNameRequiredAlert() {
        appAlert = AnyAppAlert(
            alertTitle: "Budget Name Required",
            alertSubtitle: "Please enter a name for this budget."
        )
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



#Preview {
    BudgetFormView(mode: .category, purpose: .edit(Budget.mockBudgets[0]))
        .withPreviewEnvironment()
}
