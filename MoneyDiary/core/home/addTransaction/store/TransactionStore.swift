//
//  TransactionStore.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//
import Foundation
import Combine

@MainActor
final class TransactionStore: ObservableObject {
    @Published private(set) var transactions: [Transaction] = []

    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }

    func total(for type: TransactionType) -> Double {
        transactions
            .filter { $0.transactionType == type }
            .map { $0.amount }
            .reduce(0, +)
    }
}
