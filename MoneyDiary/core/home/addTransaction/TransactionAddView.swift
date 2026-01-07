//
//  ExpenseAddView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//

import SwiftUI

struct TransactionAddView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var transactionStore: TransactionStore

    
    @State private var navigateToAddCategory:Bool = false
    @State private var transactionName: String = ""
    @State private var transactionType: TransactionType = .expense
    @State private var amount: String
    @State private var selectedCategoryId: UUID?
    @State private var selectedDate: Date = .now
    @State private var showDatePicker = false
    
    
    init(amount: String) {
        _amount = State(initialValue: amount)
    }
    
    // MARK: - Mock Categories
    private var categories: [CategoryItem]{
        categoryStore.categories
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                header
                
                Divider().opacity(0.3)
                
                formSection
                
                Divider().opacity(0.3)
                
                categorySection
                
                Spacer()
            }
        }
        .navigationDestination(
            isPresented: $navigateToAddCategory,
            destination: {
                CreateCategoryView()
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

        .foregroundStyle(.white)
    }
}

private extension TransactionAddView {
    
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Spacer()
            
            Text("$\(amount)")
                .font(.system(size: 28, weight: .bold))
            
            Spacer()
            
            Button {
                onAddTransactionPressed()
            } label: {
                Text("Add")
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
                title: "Type",
                trailing: {
                    Picker("", selection: $transactionType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
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
                .foregroundStyle(.secondary)
            
            ForEach(categories) { category in
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
                    .foregroundStyle(.secondary)
            }
            .onTapGesture {
                //navigate to add category
                navigateToAddCategory = true
            }
    }
    
    func categoryRow(_ category: CategoryItem) -> some View {
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
                
                Text("$2,500.00 left")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: selectedCategoryId == category.id
                  ? "checkmark.circle.fill"
                  : "circle")
            .foregroundStyle(selectedCategoryId == category.id ? .green : .secondary)
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
                .foregroundStyle(.secondary)
            
            Spacer()
            
            trailing()
        }
        .frame(height: 56)
    }
    
    private func onAddTransactionPressed(){
        //save the expense
        saveTransaction()
        dismiss()
        
    }
    
    private func saveTransaction() {
        guard
            let amount = Double(amount),
            let categoryId = selectedCategoryId,
            let category = categoryStore.categories.first(where: { $0.id == categoryId })
        else { return }
        
        let transaction = Transaction(
            id: UUID(),
            title: transactionName,
            amount: amount,
            date: selectedDate,
            transactionType: transactionType,
            isRecurring: false,
            categoryId: category.id
        )
        
        transactionStore.addTransaction(transaction)
        dismiss()
    }

   
    
}





#Preview {
    TransactionAddView(amount: "100")
}
