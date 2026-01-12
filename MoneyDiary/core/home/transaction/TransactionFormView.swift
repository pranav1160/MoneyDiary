//
//  ExpenseAddView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//

import SwiftUI



struct TransactionFormView: View {
    let purpose: TransactionFormPurpose
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var budgetManager: BudgetManager
    @EnvironmentObject private var currencyManager: CurrencyManager


    
    @State private var navigateToAddCategory:Bool = false
    @State private var transactionName: String = ""
    @State private var amount: String
    @State private var selectedCategoryId: UUID?
    @State private var selectedDate: Date = .now
    @State private var showDatePicker = false
    
    
    init(
        purpose: TransactionFormPurpose,
        amount: String = ""
    ) {
        self.purpose = purpose
        
        switch purpose {
        case .create:
            _transactionName = State(initialValue: "")
            _amount = State(initialValue: amount)
            _selectedCategoryId = State(initialValue: nil)
            _selectedDate = State(initialValue: .now)
            
        case .edit(let transaction):
            _transactionName = State(initialValue: transaction.title)
            _amount = State(initialValue: String(abs(transaction.amount)))
            _selectedCategoryId = State(initialValue: transaction.categoryId)
            _selectedDate = State(initialValue: transaction.date)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider().opacity(0.3)
            
            ScrollView {
                VStack(spacing: 0) {
                    formSection
                    Divider().opacity(0.3)
                    categorySection
                }
            }
        }
        .background(.background)


        .navigationDestination(
            isPresented: $navigateToAddCategory,
            destination: {
                CategoryFormView(mode: .create)
                    .presentationDetents([.medium])
            }
        )
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 16) {
                Capsule()
                    .fill(.secondary)
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                
                DatePicker(
                    "Select date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Button("Done") {
                    showDatePicker = false
                }
                .font(.headline)
                .padding()
            }
            .presentationDetents([.medium])
        }
    }
}

private extension TransactionFormView {
    
    private var existingId: UUID {
        if case .edit(let transaction) = purpose {
            return transaction.id
        }
        return UUID()
    }

    
    private var isCreateMode: Bool {
        if case .create = purpose {
            return true
        }
        return false
    }

    
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Spacer()
            
            Text("\(currencyManager.selectedCurrency.symbol)\(amount)")
                .font(.system(size: 28, weight: .bold))
            
            Spacer()
            
            Button {
                onSaveTransactionPressed()
            } label: {
                Text(isCreateMode ? "Add" : "Update")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.green)
                    .clipShape(Capsule())
            }

        }
        .padding()
    }
    
    var formSection: some View {
        VStack(spacing: 0) {
            
            row(
                title: "For",
                trailing: {
                    TextField("What did you spend on?", text: $transactionName)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                    
                }
            )
            
         

            
            row(
                title: "Date",
                trailing: {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            )
            .contentShape(Rectangle())
            .onTapGesture {
                showDatePicker = true
            }

            
            row(
                title: "Repeat",
                trailing: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        Text("Never")
                    }
                }
            )
        }
        .padding(.horizontal)
    }
    
    var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("CATEGORIES")
                .font(.caption)
                .foregroundStyle(.appSecondary)
            
            ForEach(categoryStore.categories) { category in
                categoryRow(category)
            }
            
            addCategoryButton
        }
        .padding()
    }
    
    var addCategoryButton: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
            .frame(height: 52)
            .overlay {
                Text("Add new category")
                    .foregroundStyle(.appSecondary)
            }
            .onTapGesture {
                //navigate to add category
                navigateToAddCategory = true
            }
    }
    
    func categoryRow(_ category: Category) -> some View {
        HStack(spacing: 12) {
            
            ZStack {
                Circle()
                    .fill(category.categoryColor)
                    .frame(width: 44, height: 44)
                
                Text(category.emoji)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.headline)
                
                if let status = budgetStatus(for: category) {
                    Text(
                        "\(currencyManager.selectedCurrency.symbol)\(Int(status.remaining)) left"
                    )
                        .font(.caption)
                        .foregroundStyle(
                            status.isOverBudget ? .red : .appSecondary
                        )
                } else {
                    Text("No budget")
                        .font(.caption)
                        .foregroundStyle(.appSecondary)
                }

            }
            
            Spacer()
            
            Image(systemName: selectedCategoryId == category.id
                  ? "checkmark.circle.fill"
                  : "circle")
            .foregroundStyle(selectedCategoryId == category.id ? .green : .appSecondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectedCategoryId = category.id
        }
    }
    
    
    func row<Content: View>(
        title: String,
        @ViewBuilder trailing: () -> Content
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.appSecondary)
            
            Spacer()
            
            trailing()
        }
        .frame(height: 56)
    }
    
    private func budgetStatus(for category: Category) -> BudgetStatus? {
        budgetManager.budgetStatuses.first {
            $0.budget.categoryId == category.id && $0.budget.isActive
        }
    }
    
    private var currencySymbol:String{
        return currencyManager.selectedCurrency.symbol
    }

    
    private func onSaveTransactionPressed() {
        saveTransaction()
        dismiss()
    }

    
    private func saveTransaction() {
        guard
            let amount = Double(amount),
            let categoryId = selectedCategoryId
        else {
            print("Invalid transaction")
            return
        }
        
        let transaction = Transaction(
            id: existingId,
            title: transactionName,
            amount: amount,
            date: selectedDate,
            isRecurring: false,
            categoryId: categoryId
        )
        
        switch purpose {
        case .create:
            transactionStore.add(transaction)
            
        case .edit:
            transactionStore.update(transaction)
        }
    }


   
    
}

#Preview {
    TransactionFormView(purpose: .create, amount: "100")
        .environmentObject(TransactionStore())
        .environmentObject(CategoryStore())
        .environmentObject(
            BudgetManager(
                budgetStore: BudgetStore(),
                transactionStore: TransactionStore()
            )
        )
}
