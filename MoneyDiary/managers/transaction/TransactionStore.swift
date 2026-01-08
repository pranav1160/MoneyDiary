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
    
    init(){
        loadMockTransactions()
    }
    // MARK: - Mutations
    
    func add(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
    }
    
    func delete(id: UUID) {
        transactions.removeAll { $0.id == id }
    }
    
    func update(_ updated: Transaction) {
        guard let index = transactions.firstIndex(where: { $0.id == updated.id }) else {
            return
        }
        transactions[index] = updated
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { transactions[$0].id }.forEach(delete)
    }

    
    // MARK: - Mocks (internal write access)
    func loadMockTransactions() {
        transactions = Transaction.transactionMocks
    }
    
}
