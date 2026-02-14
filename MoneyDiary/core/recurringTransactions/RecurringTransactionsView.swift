//
//  RecurringTransactionsView.swift
//  MoneyDiary
//
//  Created by Pranav on 18/01/26.
//

import SwiftUI
import SwiftData

struct RecurringTransactionsView: View {
    
    @EnvironmentObject private var transactionStore: TransactionStore
    @State private var isEditing: Bool = false
    
    private static let templateSource = TransactionSource.recurringTemplate
    private static let pausedSource   = TransactionSource.recurringPaused
    
    @Query(sort: \Transaction.date, order: .reverse)
    private var allTransactions: [Transaction]
    
    private var recurringTransactions: [Transaction] {
        allTransactions.filter {
            $0.source == .recurringTemplate ||
            $0.source == .recurringPaused
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationHeader(
                title: "Recurring Transactions",
                showsBackButton: true
            ) {
                ToolBarCircleButton(systemImage: isEditing ? "checkmark" : "pencil") {
                    withAnimation { isEditing.toggle() }
                }
                .disabled(recurringTransactions.isEmpty)
                .opacity(recurringTransactions.isEmpty ? 0.4 : 1)

            }
            
            if recurringTransactions.isEmpty {
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
            ForEach(recurringTransactions) { transaction in
                RecurringTransactionRow(
                    transaction: transaction,
                    isEditing: $isEditing
                )
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    RecurringTransactionSwipeActions(
                        transaction: transaction,
                        store: transactionStore
                    )
                }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    let preview = Preview(Category.self, Budget.self)
    preview.addSamples(
        categories: Category.mockCategories,
        budgets: Budget.mockBudgets
    )
    
    return NavigationStack {
        RecurringTransactionsView()
            .withPreviewEnvironment(container: preview.container)
    }
}
