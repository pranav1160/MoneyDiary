//
//  ExpenseAddView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//

import SwiftUI

struct TransactionFormView: View {
    let purpose: TransactionFormPurpose
    let onFinish: () -> Void
    
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var budgetManager: BudgetManager
    @EnvironmentObject private var currencyManager: CurrencyManager
    @Environment(\.dismiss) private var dismiss

    
    @State private var navigateToAddCategory:Bool = false
    @State private var transactionName: String = ""
    @State private var amount: String
    @State private var selectedCategoryId: UUID?
    @State private var selectedDate: Date = .now
    @State private var showDatePicker = false
    
    
    @State private var appAlert: AnyAppAlert?
    @State var recurrencePattern: RecurrencePattern?
    @State private var showRecurrencePicker = false
    
    init(
        purpose: TransactionFormPurpose,
        onFinish: @escaping () -> Void,
        amount: String = ""
        
    ) {
        self.purpose = purpose
        self.onFinish = onFinish
        switch purpose {
        case .create:
            _transactionName = State(initialValue: "")
            _amount = State(initialValue: amount)
            _selectedCategoryId = State(initialValue: nil)
            _selectedDate = State(initialValue: .now)
            _recurrencePattern = State(initialValue: nil)
            
        case .edit(let transaction):
            _transactionName = State(initialValue: transaction.title ?? "")
            _amount = State(
                initialValue: amount.isEmpty
                ? String(abs(transaction.amount))
                : amount
            )
            _selectedCategoryId = State(initialValue: transaction.categoryId)
            _selectedDate = State(initialValue: transaction.date)
            _recurrencePattern = State(
                initialValue: transaction.recurrenceInfo?.pattern
            )
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider().opacity(0.3)
            
            ScrollView {
                VStack(spacing: 0) {
                    formSection
                    Divider().opacity(0.5)
                    deleteSection
                    Divider().opacity(0.5)
                    categorySection
                    
                }
            }
        }
        .background(.background)
        .navigationDestination(
            isPresented: $navigateToAddCategory
        ) {
            CategoryFormView(
                mode: .create,
                onCategorySaved: { newCategory in
                    withAnimation {
                        selectedCategoryId = newCategory.id   //  auto-select
                    }
                }
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showRecurrencePicker) {
            RecurrencePickerView(
                selectedPattern: $recurrencePattern
            )
            .presentationDetents([.medium])
        }
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
        .hideSystemNavigation()
        .showCustomAlert(
            type: .alert,
            alert: $appAlert
        )


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
        CustomNavigationHeader(
            title: "\(currencyManager.selectedCurrency.symbol)\(amount)",
            showsBackButton: true) {
                ToolBarCapsuleButton(
                    title: isCreateMode ? "Add" : "Update") {
                        onSaveTransactionPressed()
                    }
            }
    }
    
    var formSection: some View {
        VStack(spacing: 0) {
            
            row(
                title: "For",
                trailing: {
                    TextField("Add a note?", text: $transactionName)
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

            if isCreateMode{
                row(
                    title: "Repeat",
                    trailing: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                            Text(recurrencePattern?.description ?? "Never")
                                .foregroundStyle(.primary)
                        }
                    }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    showRecurrencePicker = true
                }
            }
            
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
    
    
    @ViewBuilder
    var deleteSection: some View {
        if case .edit(let transaction) = purpose {
            Button(role: .destructive) {
                confirmDelete(transaction)
            } label: {
                HStack{
                    Image(systemName: "trash")
                    Text("Delete Transaction")
                    Spacer()
                }
                .padding()
                .contentShape(Rectangle())
            }
            
        }
    }

    
    var addCategoryButton: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
            .frame(height: 52)
            .contentShape(Rectangle())
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
    
    
    private func confirmDelete(_ transaction: Transaction) {
        appAlert = AnyAppAlert(
            alertTitle: "Delete Transaction?",
            alertSubtitle: "This action cannot be undone."
        ) {
            AnyView(
                HStack {
                    Button("Cancel", role: .cancel) {}
                    
                    Button("Delete", role: .destructive) {
                        transactionStore.delete(id: transaction.id)
                        
                        // 🔑 CRITICAL FIX
                        appAlert = nil
                        DispatchQueue.main.async {
                            onFinish()
                        }
                    }
                }
            )
        }
    }



    
    private func onSaveTransactionPressed() {
        guard selectedCategoryId != nil else {
            showCategoryRequiredAlert()
            return
        }
        
        saveTransaction()
        onFinish()
    }

    
    private func saveTransaction() {
        guard
            let amount = Double(amount),
            let categoryId = selectedCategoryId
        else {
            print("Invalid transaction")
            return
        }
        
        let trimmedTitle = transactionName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let recurrenceInfo: RecurrenceInfo? = {
            switch purpose {
            case .create:
                return makeRecurrenceInfo()
                
            case .edit(let existing):
                //  recurrenceInfo is IMMUTABLE in edit mode
                return existing.recurrenceInfo
            }
        }()

        
        let source: TransactionSource = {
            switch purpose {
            case .create:
                return recurrenceInfo != nil ? .recurringTemplate : .manual
                
            case .edit(let existing):
                // NEVER recompute source on edit
                return existing.source
            }
        }()


        
        let transaction = Transaction(
            id: existingId,
            title: trimmedTitle.isEmpty ? nil : trimmedTitle,
            amount: amount,
            date: selectedDate,
            categoryId: categoryId,
            recurrenceInfo: recurrenceInfo,
            source: source
        )

        
        switch purpose {
        case .create:
            transactionStore.add(transaction)
            
        case .edit:
            transactionStore.update(transaction)
        }
    }

    
    private func makeRecurrenceInfo() -> RecurrenceInfo? {
        guard let pattern = recurrencePattern else {
            return nil
        }
        
        let now = Date()
        
        // First occurrence should be generated immediately if date <= now
        let firstOccurrence =
        selectedDate <= now ? selectedDate : selectedDate
        
        return RecurrenceInfo(
            pattern: pattern,
            nextOccurrence: firstOccurrence
        )
    }


   


}

#Preview {
    TransactionFormView(
        purpose: .edit(Transaction.mocks[0]),
        onFinish: {},
        amount: "100"
        
    )
    .withPreviewEnvironment()
}
