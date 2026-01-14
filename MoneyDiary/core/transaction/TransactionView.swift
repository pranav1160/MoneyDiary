//
//  ReportView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

enum Route: Hashable {
    case amount
    case create(amount: String)
    case edit(transactionId: UUID)
}



struct TransactionView: View {
    @State private var path = NavigationPath()
    @EnvironmentObject private var transactionStore: TransactionStore
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    Button("Add Transaction") {
                        path.append(Route.amount)
                    }
                }
                
                Section("Transactions") {
                    ForEach(transactionStore.transactions) { transaction in
                        Button {
                            path.append(Route.edit(transactionId: transaction.id))
                        } label: {
                            TransactionRow(transaction: transaction)
                        }

                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                    
                case .amount:
                    AmountDialPadView(
                        onContinue: { amount in
                            path.append(Route.create(amount: amount))
                        }
                    )
                    
                case .create(let amount):
                    TransactionFormView(
                        purpose: .create,
                        onFinish: {
                            path.removeLast(path.count) // 🔥 POP BOTH
                        },
                        amount: amount
                        
                    )
                    
                case .edit(let transactionId):
                    if let transaction = transactionStore.transactions.first(where: {
                        $0.id == transactionId
                    }) {
                        TransactionFormView(
                            purpose: .edit(transaction),
                            onFinish: {
                                path.removeLast()
                            }
                        )
                    }

                }
            }
            .navigationTitle("Transactions")
        }
    }
}


#Preview {
    TransactionView()
        .environmentObject(TransactionStore())
}
