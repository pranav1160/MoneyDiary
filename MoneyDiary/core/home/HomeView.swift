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
        transactionStore.totalThisMonth()
    }
   



    
    private var summarySection: some View {
        HStack(spacing: 24) {
            
            VStack(spacing: 8) {
                AnimatedCircleProgress(
                    strokeColor: .red,
                    inputVal: monthlyExpense,
                    totalVal: 50000,
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
                CategoryFormView(mode: .create)
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
                VStack(spacing: 10) {
                    ForEach(categoryStore.categories) { category in
                        NavigationLink {
                            CategoryFormView(mode: .edit(category))
                        } label: {
                            CategoryRow(category: category)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
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

