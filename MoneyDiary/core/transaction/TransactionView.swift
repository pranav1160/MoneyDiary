//
//  ReportView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct TransactionView: View {
    @EnvironmentObject private var transactionStore: TransactionStore
    
    var body: some View {
        List {
            
            // Add transaction action
            Section {
                NavigationLink {
                    AmountDialPadView()
                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    actionRow(title: "Add Transaction", color: .accent)
                }
            }
            
            // Transactions list
            Section("Transactions") {
                ForEach(transactionStore.transactions) { transaction in
                    NavigationLink {
                        TransactionFormView(purpose: .edit(transaction))
                    } label: {
                        TransactionRow(transaction: transaction)
                    }
                }
                .onDelete(perform: transactionStore.delete)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Transactions")
    }
    
    
    
    private func actionRow(title: String, color: Color) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(color)
    }
}


#Preview {
    TransactionView()
        .environmentObject(TransactionStore())
}
