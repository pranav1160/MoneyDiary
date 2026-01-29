//
//  BudgetManager.swift
//  MoneyDiary
//
//  Created by Pranav on 09/01/26.
//


import Foundation
import Combine

@MainActor
final class BudgetManager: ObservableObject {
    @Published private(set) var budgetStatuses: [BudgetStatus] = []

    private let calculator = BudgetCalculator()

    private let budgetStore: BudgetStore
    private let transactionStore: TransactionStore

    private var cancellables = Set<AnyCancellable>()

    init(
        budgetStore: BudgetStore,
        transactionStore: TransactionStore
    ) {
        
        self.budgetStore = budgetStore
        self.transactionStore = transactionStore
//        bind()
    }

//    private func bind() {
//        Publishers
//            .CombineLatest(
////                budgetStore.$budgets,
//                transactionStore.$transactions
//            )
//           
//            .map { budgets, transactions in
//                return budgets.map { budget in
//                    self.calculator.status(
////                        for: budget,
////                        allTransactions: transactions
//                    )
//                }
//            }
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$budgetStatuses)
//    }
}
