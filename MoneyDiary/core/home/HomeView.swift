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
                // MARK: - Categories Preview
                categoriesSection
                // MARK: - Quick Actions
                quickActionsSection
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
        
        

    }
    
    private var monthlyExpense: Double {
        transactionStore.totalThisMonth(for: .expense)
    }
    
    private var monthlyIncome: Double {
        transactionStore.totalThisMonth(for: .income)
    }



    
    private var summarySection: some View {
        HStack(spacing: 24) {
            
            VStack(spacing: 8) {
                AnimatedCircleProgress(
                    strokeColor: .red,
                    inputVal: monthlyExpense,
                    totalVal: monthlyIncome,
                    size: 120,
                    strokeWidth: 10
                )
                
                Text("Expense")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(monthlyExpense, format: .currency(code: "INR"))")
                    .font(.headline)
                    .foregroundStyle(.red)
            }
        }
        .padding(.horizontal)
    }



    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            NavigationLink {
                CreateCategoryView()
            } label: {
                actionRow(title: "Create Category", color: .categoryBlue)
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
                    .foregroundStyle(.appSecondary)
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
                                    .fill(category.categoryColor.color.opacity(0.7))
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

