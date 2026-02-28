//
//  RecurringTransactionSwipeActions.swift
//  MoneyDiary
//
//  Created by Pranav on 26/01/26.
//

import SwiftUI

//MARK: - swipe actions
struct RecurringTransactionSwipeActions: View {
    let transaction: Transaction
    let store: TransactionStore
    
    var body: some View {
        
        Button(role: .destructive) {
            withAnimation {
                store.deleteRecurring(id: transaction.id)
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
        
        
        if transaction.source == .recurringTemplate {
            Button {
                withAnimation {
                    store.stopRecurrence(id: transaction.id)
                }
            } label: {
                Label("Stop", systemImage: "stop.circle")
            }
            .tint(.orange)
        }
        
        if transaction.source == .recurringPaused {
            Button {
                withAnimation {
                    store.resumeRecurrence(id: transaction.id)
                }
            } label: {
                Label("Resume", systemImage: "play.circle")
            }
            .tint(.green)
        }
        
    }
}
