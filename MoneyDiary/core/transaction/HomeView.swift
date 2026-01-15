//
//  ReportView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI


struct HomeView: View {
    
    @State private var path = NavigationPath()
    @EnvironmentObject private var transactionStore: TransactionStore
    
    var body: some View {
        NavigationStack(path: $path) {
     
            recentTrancactionSection
            
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        path.append(TransactionRoute.amount)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Circle().fill(Color.accentColor))
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            
            .navigationDestination(for: TransactionRoute.self) { route in
                switch route {
                    
                case .amount:
                    AmountDialPadView(
                        onContinue: { amount in
                            path.append(TransactionRoute.create(amount: amount))
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
                    
              

                case .editAmount(let transactionId):
                    if let transaction = transactionStore.transactions.first(where: {
                        $0.id == transactionId
                    }) {
                        AmountDialPadView(
                            initialAmount: String(abs(transaction.amount)), // 👈 prefill
                            onContinue: { newAmount in
                                path.append(
                                    TransactionRoute.edit(
                                        transactionId: transactionId,
                                        amount: newAmount
                                    )
                                )
                            }
                        )
                    }
                case .edit(let transactionId, let amount):
                    if let transaction = transactionStore.transactions.first(where: {
                        $0.id == transactionId
                    }) {
                        TransactionFormView(
                            purpose: .edit(transaction),
                            onFinish: {
                                path.removeLast(path.count) // pop editAmount + edit
                            },
                            amount: amount
                           
                        )
                    }

                }
            }
            .navigationTitle("Home")
        }
    }
    
    private var recentTrancactionSection:some View{
        List {
            
            Section("Transactions") {
                ForEach(transactionStore.transactions) { transaction in
                    Button {
                        path.append(TransactionRoute.editAmount(transactionId: transaction.id))
                        
                    } label: {
                        TransactionRow(transaction: transaction)
                    }
                    
                    
                }
            }
            
        }
    }
}


#Preview {
    HomeView()
        .withPreviewEnvironment()
}
