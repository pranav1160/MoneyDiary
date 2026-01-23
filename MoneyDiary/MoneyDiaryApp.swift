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
    
    @Environment(\.scenePhase) private var scenePhase

    @StateObject private var categoryStore = CategoryStore()
    @StateObject private var transactionStore = TransactionStore()
    @StateObject private var currencyManager = CurrencyManager()
    @StateObject private var budgetStore = BudgetStore()
    @StateObject private var toastManager = ToastManager()
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
                .environmentObject(toastManager)
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        transactionStore.processRecurringTransactions()
                    }
                }
        }
    }
}
