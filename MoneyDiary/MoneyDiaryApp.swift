//
//  MoneyDiaryApp.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI
import SwiftData

@main
struct MoneyDiaryApp: App {
    
    
    @StateObject private var categoryStore = CategoryStore()
    @StateObject private var transactionStore = TransactionStore()
    @StateObject private var currencyManager = CurrencyManager()
    @StateObject private var budgetStore = BudgetStore()
    
    var body: some Scene {
        WindowGroup {
            let budgetManager = BudgetManager(
                budgetStore: budgetStore,
                transactionStore: transactionStore
            )

            
            AppView()
                .environmentObject(categoryStore)
                .environmentObject(transactionStore)
                .environmentObject(currencyManager)
                .environmentObject(budgetStore)
                .environmentObject(budgetManager)
        }
    }
}
