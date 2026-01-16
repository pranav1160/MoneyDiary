//
//  TransactionStore.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//
import Foundation
import Combine

private func debug(_ message: String) {
#if DEBUG
    print("🧾 [TransactionStore] \(message)")
#endif
}


@MainActor
final class TransactionStore: ObservableObject {
    @Published private(set) var transactions: [Transaction] = []
   
    
    init(){
        loadMockTransactions()
        processRecurringTransactions()
    }
    
    // MARK: - Mutations
    
    func add(_ transaction: Transaction) {
        debug("ADD → id=\(transaction.id) amount=\(transaction.amount) date=\(transaction.date) recurrence=\(transaction.recurrenceInfo != nil)")
        
        addWithoutProcessing(transaction)
        processRecurringTransactions()
    }

    
    func delete(id: UUID) {
        transactions.removeAll { $0.id == id }
    }
    
    func update(_ updated: Transaction) {
        guard let index = transactions.firstIndex(where: { $0.id == updated.id }) else {
            debug("UPDATE FAILED → id=\(updated.id) not found")
            return
        }
        debug("UPDATE → id=\(updated.id) recurrence=\(updated.recurrenceInfo != nil)")
        transactions[index] = updated
    }
    
    func delete(at offsets: IndexSet) {
        offsets.map { transactions[$0].id }.forEach(delete)
    }

    
    // MARK: - Mocks (internal write access)
    func loadMockTransactions() {
        transactions = Transaction.mocks
    }
    
    private func addWithoutProcessing(_ transaction: Transaction) {
        debug("ADD (internal) → id=\(transaction.id) date=\(transaction.date)")
        transactions.insert(transaction, at: 0)
        transactions.sort { $0.date > $1.date }
    }

    
}


//Recurring
extension TransactionStore{
    func processRecurringTransactions() {
        let now = Date()
        debug("PROCESS START → now=\(now)")
        
        var transactionsToAdd: [Transaction] = []
        var transactionsToUpdate: [Transaction] = []
        
        for transaction in transactions where transaction.recurrenceInfo != nil {
            
            debug("TEMPLATE FOUND → id=\(transaction.id) date=\(transaction.date)")
            
            guard var recurrence = transaction.recurrenceInfo else { continue }
            
            while now >= recurrence.nextOccurrence {
                debug("  GENERATE → next=\(recurrence.nextOccurrence)")
                
                let newTransaction = Transaction(
                    id: UUID(),
                    title: transaction.title,
                    amount: transaction.amount,
                    date: recurrence.nextOccurrence,
                    categoryId: transaction.categoryId,
                    recurrenceInfo: nil
                )
                
                let exists = transactions.contains {
                    $0.date == recurrence.nextOccurrence &&
                    $0.amount == transaction.amount &&
                    $0.categoryId == transaction.categoryId &&
                    $0.recurrenceInfo == nil
                }
                
                if exists {
                    debug("  SKIP (duplicate) → date=\(recurrence.nextOccurrence)")
                } else {
                    debug("  ADD INSTANCE → date=\(recurrence.nextOccurrence)")
                    transactionsToAdd.append(newTransaction)
                }
                
                recurrence = recurrence.updatingNextOccurrence()
                debug("  ADVANCE → next=\(recurrence.nextOccurrence)")
            }
            
            if recurrence != transaction.recurrenceInfo {
                debug("TEMPLATE ADVANCED → id=\(transaction.id) newNext=\(recurrence.nextOccurrence)")
                
                let updatedTransaction = Transaction(
                    id: transaction.id,
                    title: transaction.title,
                    amount: transaction.amount,
                    date: transaction.date,
                    categoryId: transaction.categoryId,
                    recurrenceInfo: recurrence
                )
                
                transactionsToUpdate.append(updatedTransaction)
            }
        }
        
        debug("PROCESS APPLY → add=\(transactionsToAdd.count) update=\(transactionsToUpdate.count)")
        
        for newTx in transactionsToAdd {
            addWithoutProcessing(newTx)
        }

        
        for updatedTx in transactionsToUpdate {
            update(updatedTx)
        }
        
        debug("PROCESS END")
    }

}



