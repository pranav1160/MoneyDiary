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

    var body: some View {
        HStack(spacing: 12) {

            Text(category?.emoji ?? "❓")
                .font(.title2)

            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)

                Text(category?.title ?? "Unknown")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("₹\(transaction.amount, specifier: "%.0f")")
                .foregroundStyle(
                    transaction.transactionType == .expense ? .red : .green
                )
        }
        .padding()
    }
}
