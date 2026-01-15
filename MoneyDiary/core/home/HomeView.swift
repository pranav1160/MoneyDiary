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
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack{
                CustomNavigationHeader(title: "Home",showsBackButton: false) {
                    ToolBarCircleButton(systemImage: "gearshape") {
                        showSettings = true
                    }
                }
                .overlay(alignment: .leading) {
                    LogoView(size: 50)
                        .padding(.leading,8)
                }
                recentTrancactionSection
            }
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
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
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
            
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
    
    private var recentTrancactionSection: some View {
        List {
            ForEach(transactionStore.transactionsGroupedByDay(), id: \.date) { section in
                Section(header: dateHeader(section.date)) {
                    ForEach(section.transactions) { transaction in
                        Button {
                            path.append(
                                TransactionRoute.editAmount(transactionId: transaction.id)
                            )
                        } label: {
                            TransactionRow(transaction: transaction)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private func dateHeader(_ date: Date) -> some View {
        let calendar = Calendar.current
        
        let text: String
        if calendar.isDateInToday(date) {
            text = "Today"
        } else if calendar.isDateInYesterday(date) {
            text = "Yesterday"
        } else {
            text = date.formatted(.dateTime.day().month().year())
        }
        
        return Text(text)
            .font(.footnote)
            .foregroundStyle(.appSecondary)
    }
    
    
}


#Preview {
    HomeView()
        .withPreviewEnvironment()
}
