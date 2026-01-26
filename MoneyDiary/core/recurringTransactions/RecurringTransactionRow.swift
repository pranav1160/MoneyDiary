//
//  RecurringTransactionRow.swift
//  MoneyDiary
//
//  Created by Pranav on 26/01/26.
//
import SwiftUI

// MARK: - Row

struct RecurringTransactionRow: View {
    let transaction: Transaction
    @Binding var isEditing:Bool
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var transactionStore: TransactionStore
    
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
                    }
                    .foregroundStyle(.appSecondary)
                }
            }
            .overlay(alignment: .topTrailing) {
                if transaction.source == .recurringPaused {
                    Text("Paused")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.15))
                        )
                }
            }

            
            Spacer()
            
            ZStack(alignment: .trailing) {
                
                // Amount (view mode)
                Text(transaction.amount, format: .currency(code: "INR"))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(transaction.amount >= 0 ? .green : .red)
                    .opacity(isEditing ? 0 : 1)
                    .offset(x: isEditing ? -8 : 0)
                
                // Action buttons (edit mode)
                HStack(spacing: 12) {
                    
                    SwipeActionButton(
                        systemImage: "trash",
                        backgroundColor: .red
                    ) {
                        withAnimation {
                            transactionStore.deleteRecurring(id: transaction.id)
                        }
                    }

                    
                    if transaction.source == .recurringTemplate {
                        SwipeActionButton(
                            systemImage: "stop.circle",
                            backgroundColor: .orange
                        ) {
                            withAnimation {
                                transactionStore.stopRecurrence(id: transaction.id)
                            }
                        }
                    }
                    
                    if transaction.source == .recurringPaused {
                        SwipeActionButton(
                            systemImage: "play.circle",
                            backgroundColor: .green
                        ) {
                            withAnimation {
                                transactionStore.resumeRecurrence(id: transaction.id)
                            }
                        }
                    }
                }
                .opacity(isEditing ? 1 : 0)
                .offset(x: isEditing ? 0 : 8)
            }
            .animation(.easeInOut(duration: 0.2), value: isEditing)

            
            
        }
        .padding(.vertical, 4)
    }
}
