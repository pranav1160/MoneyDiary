//
//  HomeView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var transactionStore: TransactionStore
    
    @State private var showSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Header
                HStack {
                    Text("Overview")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                
                // MARK: - Summary Cards
                summarySection
                
                // MARK: - Quick Actions
                quickActionsSection
                
                // MARK: - Categories Preview
                categoriesSection
                
                ForEach(transactionStore.transactions) { transaction in
                    NavigationLink {
                        TransactionDetailView(transaction: transaction)
                    } label: {
                        TransactionRow(transaction: transaction)
                    }
                }


            }
            .padding(.bottom, 40)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .navigationDestination(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            print("Home categories:", categoryStore.categories)
            print("Added category, total:", categoryStore.categories.count)
        }
        

    }
    
    private var totalExpense: Double {
        transactionStore.transactions
            .filter { $0.transactionType == .expense }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    private var totalIncome: Double {
        transactionStore.transactions
            .filter { $0.transactionType == .income }
            .map { $0.amount }
            .reduce(0, +)
    }

    
    private var summarySection: some View {
        HStack(spacing: 16) {
            
            summaryCard(
                title: "Expense",
                value: totalExpense,
                color: .red
            )
            
            summaryCard(
                title: "Income",
                value: totalIncome,
                color: .green
            )
        }
        .padding(.horizontal)
    }

    private func summaryCard(
        title: String,
        value: Double,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("₹\(value, specifier: "%.0f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }

    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            
            NavigationLink {
                CreateCategoryView()
            } label: {
                actionRow(title: "Create Category", color: .categoryBlue)
            }
            
            NavigationLink {
                AmountDialPadView()
                    .toolbar(.hidden, for: .tabBar)
            } label: {
                actionRow(title: "Add Expense", color: .accent)
            }
        }
        .padding(.horizontal)
    }

    private func actionRow(title: String, color: Color) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
    }
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Categories")
                .font(.headline)
                .padding(.horizontal)
            
            if categoryStore.categories.isEmpty {
                Text("No categories yet")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categoryStore.categories) { category in
                            VStack(spacing: 6) {
                                Text(category.emoji)
                                    .font(.largeTitle)
                                
                                Text(category.title)
                                    .font(.caption)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.ultraThinMaterial)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
  


}

#Preview {
    NavigationStack{
        HomeView()
            .environmentObject(CategoryStore())
            .environmentObject(TransactionStore())
    }
}

