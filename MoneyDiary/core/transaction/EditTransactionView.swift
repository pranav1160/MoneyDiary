//
//  EditTransactionView.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//


import SwiftUI

struct EditTransactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var transactionStore: TransactionStore
    
    @State private var title: String
    @State private var amount: String
    @State private var date: Date
    @State private var type: TransactionType
    
    private let transaction: Transaction
    
    init(transaction: Transaction) {
        self.transaction = transaction
        _title = State(initialValue: transaction.title)
        _amount = State(initialValue: String(transaction.amount))
        _date = State(initialValue: transaction.date)
        _type = State(initialValue: transaction.transactionType)
    }
    
    var body: some View {
        Form {
            
            Section("Details") {
                TextField("Title", text: $title)
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                Picker("Type", selection: $type) {
                    ForEach(TransactionType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            
            Section {
                Button("Save Changes") {
                    save()
                }
                .font(.headline)
            }
        }
        .navigationTitle("Edit Transaction")
    }
    
    private func save() {
        guard let amount = Double(amount) else { return }
        
        let updated = Transaction(
            id: transaction.id,
            title: title,
            amount: amount,
            date: date,
            transactionType: type,
            isRecurring: transaction.isRecurring,
            categoryId: transaction.categoryId
        )
        
        transactionStore.update(updated)
        dismiss()
    }
}

#Preview {
    EditTransactionView(transaction: Transaction.transactionMocks[0])
}
