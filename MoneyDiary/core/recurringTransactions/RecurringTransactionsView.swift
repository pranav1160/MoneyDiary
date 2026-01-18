//
//  RecurringTransactionsView.swift
//  MoneyDiary
//
//  Created by Pranav on 18/01/26.
//

import SwiftUI

struct RecurringTransactionsView: View {
    @EnvironmentObject private var transactionStore: TransactionStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationHeader(
                title: "Recurring Transactions",
                showsBackButton: true
            ) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.primary)
                }
            }
            
            if transactionStore.recurringTransactions.isEmpty {
                emptyState
            } else {
                recurringList
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.clockwise.circle")
                .font(.system(size: 60))
                .foregroundStyle(.appSecondary)
            
            Text("No Recurring Transactions")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.primary)
            
            Text("Create a transaction with recurrence to see it here")
                .font(.subheadline)
                .foregroundStyle(.appSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - List
    
    private var recurringList: some View {
        List {
            ForEach(transactionStore.recurringTransactions) { transaction in
                RecurringTransactionRow(transaction: transaction)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        
                        // DELETE (always available)
                        Button(role: .destructive) {
                            withAnimation {
                                transactionStore.deleteRecurringTemplate(id: transaction.id)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        // STOP / RESUME
                        if transaction.source == .recurringTemplate {
                            Button {
                                withAnimation {
                                    transactionStore.stopRecurrence(id: transaction.id)
                                }
                            } label: {
                                Label("Stop", systemImage: "stop.circle")
                            }
                            .tint(.orange)
                        }
                        
                        if transaction.source == .recurringPaused {
                            Button {
                                withAnimation {
                                    transactionStore.resumeRecurrence(id: transaction.id)
                                }
                            } label: {
                                Label("Resume", systemImage: "play.circle")
                            }
                            .tint(.green)
                        }
                    }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Row

struct RecurringTransactionRow: View {
    let transaction: Transaction
    @EnvironmentObject private var categoryStore: CategoryStore
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Category Icon
            if let category = categoryStore.categories.first(
                where: { $0.id == transaction.categoryId }
            ) {
                Text(category.emoji)
                    .font(.title3)
                    .frame(width: 36, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(category.categoryColor.color.opacity(0.25))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.displayTitle(using: categoryStore.categories))
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color.primary)

                
                if let recurrence = transaction.recurrenceInfo {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption2)
                        
                        Text(recurrence.pattern.description)
                            .font(.caption)
                        
                        Text("•")
                            .font(.caption2)
                        
                        let nextDateText = recurrence.nextOccurrence.formatted(
                            .dateTime.month(.abbreviated).day()
                        )
                        
                        Text("Next: \(nextDateText)")
                            .font(.caption)

                        .font(.caption)
                    }
                    .foregroundStyle(.appSecondary)
                }
                
                // PAUSED BADGE
                if transaction.source == .recurringPaused {
                    Text("Paused")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
            }
            
            Spacer()
            
            Text(transaction.amount, format: .currency(code: "INR"))
                .font(.body.weight(.semibold))
                .foregroundStyle(transaction.amount >= 0 ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        RecurringTransactionsView()
            .withPreviewEnvironment()
    }
}
