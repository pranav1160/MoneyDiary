//
//  TransactionDetailView.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//


import SwiftUI

struct TransactionDetailView: View {

    let transaction: Transaction

    @EnvironmentObject private var categoryStore: CategoryStore
    @Environment(\.dismiss) private var dismiss

    private var category: CategoryItem? {
        categoryStore.categories.first {
            $0.id == transaction.categoryId
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Emoji + Amount
                VStack(spacing: 12) {
                    Text(category?.emoji ?? "❓")
                        .font(.system(size: 60))

                    Text("₹\(transaction.amount, specifier: "%.0f")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            transaction.transactionType == .expense ? .red : .green
                        )
                }

                // MARK: - Details Card
                VStack(spacing: 16) {
                    detailRow(title: "Title", value: transaction.title)
                    detailRow(title: "Type", value: transaction.transactionType.rawValue)
                    detailRow(title: "Category", value: category?.title ?? "Unknown")
                    detailRow(
                        title: "Date",
                        value: transaction.date.formatted(date: .abbreviated, time: .shortened)
                    )
                    detailRow(
                        title: "Recurring",
                        value: transaction.isRecurring ? "Yes" : "No"
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
            }
            .padding()
        }
        .navigationTitle("Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }

    // MARK: - Reusable Row
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
        }
    }
}

