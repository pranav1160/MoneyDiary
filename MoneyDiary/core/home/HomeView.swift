//
//  HomeView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct HomeView: View {
   
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

    
  
    
  


}

#Preview {
    NavigationStack{
        HomeView()
            .environmentObject(CategoryStore())
            .environmentObject(TransactionStore())
    }
}

