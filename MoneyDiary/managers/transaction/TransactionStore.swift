//
//  TransactionStore.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//
import Foundation
import Combine
import SwiftUI
import SwiftData

private func debug(_ message: String) {
#if DEBUG
    print("🧾 [TransactionStore] \(message)")
#endif
}

@MainActor
final class TransactionStore: ObservableObject {
    private let context: ModelContext
    
    init(context: ModelContext){
        self.context = context
    }
    
    // MARK: - Mutations
    
    func add(_ transaction: Transaction) {
        debug("ADD → \(transaction.id)")
        context.insert(transaction)
        
        if transaction.source == .recurringTemplate {
            processRecurringTransactions()
        }
        
        save()
    }

    
     func save() {
        do {
            try context.save()
        } catch {
            debug("SAVE FAILED → \(error)")
        }
    }

    
    func delete(id: UUID) {
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { $0.id == id }
        )
        if let tx = try? context.fetch(descriptor).first {
            context.delete(tx)
            save()
        }
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
        
        context.insert(repeatedTransaction)
        save()
    }

    
}


//Recurring
extension TransactionStore{
    // MARK: - Recurring Management
    
    /// Stops a recurring transaction by converting it to manual
    func stopRecurrence(id: UUID) {
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let tx = try? context.fetch(descriptor).first,
        tx.sourceRaw == "recurringTemplate" else { return }
        
        tx.source = .recurringPaused
        save()
        debug("STOP → id=\(id) paused")
    }
    
    
    
    /// Deletes a recurring template and optionally all generated instances
    /// Deletes a recurring template and optionally all generated instances
    func deleteRecurring(id: UUID, deleteAllInstances: Bool = false) {
        
        // 1️⃣ Fetch the template / paused recurring transaction
        let templateDescriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { tx in
                tx.id == id &&
                (tx.sourceRaw == "recurringTemplate" ||
                 tx.sourceRaw == "recurringPaused")
            }
        )
        
        guard let template = try? context.fetch(templateDescriptor).first else {
            debug("DELETE FAILED → id=\(id) not found or not recurring")
            return
        }
        
        // 2️⃣ Read EVERYTHING off the model object NOW, before any delete.
        //    SwiftData invalidates backing data the moment context.delete()
        //    is called — any property access after that point crashes.
        let title      = template.title
        let amount     = template.amount
        let categoryId = template.categoryId
        let sourceRaw  = template.sourceRaw   // grab this too, just in case
        _ = template.recurrenceInfo            // force-resolve the fault NOW
        
        debug("DELETE RECURRING → id=\(id), source=\(sourceRaw)")
        
        // 3️⃣ Optionally fetch generated instances BEFORE deleting the template
        var instancesToDelete: [Transaction] = []
        if deleteAllInstances {
            let generatedDescriptor = FetchDescriptor<Transaction>(
                predicate: #Predicate { tx in
                    tx.sourceRaw == "recurringGenerated" &&
                    tx.title == title &&
                    tx.amount == amount &&
                    tx.categoryId == categoryId
                }
            )
            instancesToDelete = (try? context.fetch(generatedDescriptor)) ?? []
        }
        
        // 4️⃣ Now delete everything — template first, then instances
        context.delete(template)
        
        for tx in instancesToDelete {
            context.delete(tx)
        }
        debug("DELETE INSTANCES → count=\(instancesToDelete.count)")
        
        // 5️⃣ Persist
        do {
            try context.save()
        } catch {
            debug("DELETE SAVE FAILED → \(error)")
        }
    }


    
    /// Resume a stopped recurring transaction
    func resumeRecurrence(id: UUID) {
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let tx = try? context.fetch(descriptor).first,
              tx.sourceRaw == "recurringPaused",
              var recurrence = tx.recurrenceInfo else { return }
        
        let now = Date()
        while recurrence.nextOccurrence <= now {
            recurrence = recurrence.updatingNextOccurrence()
        }
        
        tx.source = .recurringTemplate
        tx.recurrenceInfo = recurrence
        
        
        processRecurringTransactions()
        save()
    }
    
    func processRecurringTransactions() {
        let now = Date()
        debug("PROCESS START → now=\(now)")
        
        
        let templateDescriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { tx in
                tx.sourceRaw == "recurringTemplate"
            }
        )


        
        guard let templates = try? context.fetch(templateDescriptor) else {
            debug("PROCESS FAILED → fetch error")
            return
        }
        
        for template in templates {
            debug("TEMPLATE FOUND → id=\(template.id)")
            
            guard var recurrence = template.recurrenceInfo else { continue }
            
            while now >= recurrence.nextOccurrence {
                let occurrenceDate = recurrence.nextOccurrence
                let categoryId = template.categoryId
                
                debug("  GENERATE → next=\(occurrenceDate)")
                
               
                let duplicateDescriptor = FetchDescriptor<Transaction>(
                    predicate: #Predicate { tx in
                        tx.date == occurrenceDate &&
                        tx.categoryId == categoryId &&
                        tx.sourceRaw == "recurringGenerated"

                    }
                )
                
                let alreadyExists =
                (try? context.fetch(duplicateDescriptor).isEmpty) == false
                
                if alreadyExists {
                    debug("  SKIP (duplicate) → date=\(occurrenceDate)")
                } else {
                    let generated = Transaction(
                        id: UUID(),
                        title: template.title,
                        amount: template.amount,
                        date: occurrenceDate,
                        categoryId: categoryId,
                        recurrenceInfo: nil,
                        source: .recurringGenerated
                    )

                    
                    context.insert(generated)
                    debug("  ADD INSTANCE → date=\(occurrenceDate)")
                }
                
                recurrence = recurrence.updatingNextOccurrence()
                debug("  ADVANCE → next=\(recurrence.nextOccurrence)")
            }
            
            if recurrence != template.recurrenceInfo {
                template.recurrenceInfo = recurrence
                debug("TEMPLATE ADVANCED → id=\(template.id)")
            }
        }
        
        do {
            try context.save()
            debug("PROCESS END → saved")
        } catch {
            debug("PROCESS SAVE FAILED → \(error)")
        }
    }

}






