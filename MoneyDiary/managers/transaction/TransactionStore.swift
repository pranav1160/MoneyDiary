//
//  TransactionStore.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//
import Foundation
import Combine
import SwiftUI

private func debug(_ message: String) {
#if DEBUG
    print("🧾 [TransactionStore] \(message)")
#endif
}

@MainActor
final class TransactionStore: ObservableObject {
    @Published private(set) var transactions: [Transaction] = []
    
    init(){
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
        
        var finalTransaction = updated
        
        if transactions[index].source == .recurringGenerated {
            finalTransaction = Transaction(
                id: updated.id,
                title: updated.title,
                amount: updated.amount,
                date: updated.date,
                categoryId: updated.categoryId,
                recurrenceInfo: nil,
                source: .manual
            )
            debug("CONVERT → recurringGenerated → manual")
        }
        
        transactions[index] = finalTransaction
    }

    
    func delete(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
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
    
    func repeatTransaction(from transaction: Transaction) {
        let repeatedTransaction = Transaction(
            id: UUID(),
            title: transaction.title,
            amount: transaction.amount,
            date: Date(),                 // now
            categoryId: transaction.categoryId,
            recurrenceInfo: nil,           // manual
            source: .manual                // important
        )
        
        debug("REPEAT → original=\(transaction.id) new=\(repeatedTransaction.id)")
        
        // Add without animation wrapper
        addWithoutProcessing(repeatedTransaction)
        
        // Apply animation only to the list update
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            objectWillChange.send()
        }
    }

    
}


//Recurring
extension TransactionStore{
    /// Returns all recurring template transactions
    var recurringTransactions: [Transaction] {
        transactions
            .filter {
                $0.source == .recurringTemplate ||
                $0.source == .recurringPaused
            }
            .sorted { $0.date > $1.date }
    }
    
    
    // MARK: - Recurring Management
    
    /// Stops a recurring transaction by converting it to manual
    func stopRecurrence(id: UUID) {
        guard let index = transactions.firstIndex(where: { $0.id == id }),
              transactions[index].source == .recurringTemplate else {
            debug("STOP FAILED → id=\(id)")
            return
        }
        
        let template = transactions[index]
        
        let paused = Transaction(
            id: template.id,
            title: template.title,
            amount: template.amount,
            date: template.date,
            categoryId: template.categoryId,
            recurrenceInfo: template.recurrenceInfo, // keep it!
            source: .recurringPaused
        )
        
        transactions[index] = paused
        debug("STOP → id=\(id) paused")
    }
    
    
    
    /// Deletes a recurring template and optionally all generated instances
    func deleteRecurring(id: UUID, deleteAllInstances: Bool = false) {
        guard let index = transactions.firstIndex(where: { $0.id == id }) else {
            debug("DELETE FAILED → id=\(id) not found")
            return
        }
        
        let transaction = transactions[index]
        
        guard transaction.source == .recurringTemplate ||
                transaction.source == .recurringPaused else {
            debug("DELETE FAILED → id=\(id) not recurring")
            return
        }
        
        transactions.remove(at: index)
        debug("DELETE RECURRING → id=\(id), source=\(transaction.source)")
        
        if deleteAllInstances {
            let beforeCount = transactions.count
            transactions.removeAll {
                $0.source == .recurringGenerated &&
                $0.title == transaction.title &&
                $0.amount == transaction.amount &&
                $0.categoryId == transaction.categoryId
            }
            debug("DELETE INSTANCES → count=\(beforeCount - transactions.count)")
        }
    }

    
    /// Resume a stopped recurring transaction
    func resumeRecurrence(id: UUID) {
        guard let index = transactions.firstIndex(where: { $0.id == id }),
              transactions[index].source == .recurringPaused,
              var recurrence = transactions[index].recurrenceInfo else {
            debug("RESUME FAILED → id=\(id)")
            return
        }
        
        let paused = transactions[index]
        let now = Date()
        
        // CRITICAL FIX: Calculate the next occurrence from NOW, not from the old nextOccurrence
        // This prevents generating all the "missed" transactions during the pause
        while recurrence.nextOccurrence <= now {
            recurrence = recurrence.updatingNextOccurrence()
            debug("RESUME SKIP → skipping past occurrence: \(recurrence.nextOccurrence)")
        }
        
        debug("RESUME → new next occurrence will be: \(recurrence.nextOccurrence)")
        
        let resumed = Transaction(
            id: paused.id,
            title: paused.title,
            amount: paused.amount,
            date: paused.date,
            categoryId: paused.categoryId,
            recurrenceInfo: recurrence, // updated recurrence with future nextOccurrence
            source: .recurringTemplate
        )
        
        transactions[index] = resumed
        debug("RESUME → id=\(id)")
        
        processRecurringTransactions()
    }

    
    func processRecurringTransactions() {
        let now = Date()
        debug("PROCESS START → now=\(now)")
        
        var transactionsToAdd: [Transaction] = []
        var transactionsToUpdate: [Transaction] = []
        
        for transaction in transactions where transaction.source == .recurringTemplate {

            
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
                    recurrenceInfo: nil,
                    source: .recurringGenerated
                )
                
                let exists = transactions.contains {
                    $0.date == recurrence.nextOccurrence &&
                    $0.amount == transaction.amount &&
                    $0.categoryId == transaction.categoryId &&
                    $0.source == .recurringGenerated
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
                    recurrenceInfo: recurrence,
                    source: .recurringTemplate
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






