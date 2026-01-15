//
//  TransactionRow.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//
import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    @EnvironmentObject private var categoryStore: CategoryStore
    
    private var category: Category? {
        categoryStore.categories.first {
            $0.id == transaction.categoryId
        }
    }
    
    private var categoryColor: CategoryColor {
        categoryStore.color(for: transaction.categoryId)
    }

    
    var body: some View {
        HStack(spacing: 12) {
            // Category emoji in a compact circle
            Text(category?.emoji ?? "❓")
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(categoryColor.color.opacity(0.25))
                )

            
            // Transaction details
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 4) {
                    Text(category?.title ?? "Unknown")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if transaction.isRecurring {
                        Text("•")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        Image(systemName: "repeat")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    Text(transaction.date, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer(minLength: 8)
            
            // Amount
            Text("₹\(transaction.amount, specifier: "%.0f")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .contentShape(Rectangle())
    }
}


#Preview {
    TransactionRow(transaction: Transaction.mocks[0])
        .withPreviewEnvironment()
}
