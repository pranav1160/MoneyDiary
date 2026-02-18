//
//  TransactionRow.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//
import SwiftUI
import SwiftData

struct TransactionRow: View {
    let transaction: Transaction
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var currencyManager: CurrencyManager
    @Query(sort: \Category.title) var categories: [Category]
    @Environment(\.colorScheme) private var colorScheme

    private var category: Category? {
        categories.first {
            $0.id == transaction.categoryId
        }
    }
    
    private var categoryColor: CategoryColor {
        categoryStore.color(for: transaction.categoryId)
    }
    
    private var emojiSection:some View{
        // Category emoji in a compact circle
        Text(category?.emoji ?? "❓")
            .font(.title3)
            .frame(width: 36, height: 36)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(categoryColor.color.opacity(0.25))
                
                    .overlay(alignment: .bottomTrailing) {
                        indicatorIcon
                    }
            )
    }
    
    private var transactionDetails:some View{
        // Transaction details
        VStack(alignment: .leading, spacing: 2) {
            Text(transaction.displayTitle(
                using: categories
            ))
            .font(.subheadline)
            .fontWeight(.medium)
            .lineLimit(1)
            .foregroundStyle(.primary)
            
            
            Text(transaction.date, style: .relative)
                .font(.caption)
                .foregroundStyle(.secondary)
            
        }
    }
    private var transactionAmount:some View{
        // Amount
        Text(
            transaction.amount.formatted(
                .currency(code: currencyManager.selectedCurrency.code)
            )
        )

            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
    }
    var body: some View {
        HStack(spacing: 12) {
            
            emojiSection
            
            transactionDetails
            
            Spacer()
            
            transactionAmount
        }
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private var indicatorIcon: some View {
        switch transaction.source {
        case .manual:
            EmptyView()
        case .recurringTemplate:
            EmptyView()
            
        case .recurringGenerated:
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.caption2)
                .foregroundStyle(colorScheme == .dark ? .white : .categoryBlue4)
                .offset(x: 6, y: 6)
        case .recurringPaused:
            EmptyView()
        }
    }

}



#Preview {
    let preview = Preview(Category.self, Budget.self)
    preview.addSamples(
        categories: Category.mockCategories,
        budgets: Budget.mockBudgets
    )
    
    return   TransactionRow(transaction: Transaction.mockTransactions[0])
        .withPreviewEnvironment(container: preview.container)
    
}
