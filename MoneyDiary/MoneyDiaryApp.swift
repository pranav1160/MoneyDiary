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
    
    // ✅ Create these ONCE using a custom initializer
    @StateObject private var budgetManager: BudgetManager
    @StateObject private var timeSeriesViewModel: TimeSeriesViewModel
    @StateObject private var categoryViewModel: CategoryReportViewModel
    
    init() {
        // Create stores first
        let budgetStore = BudgetStore()
        let transactionStore = TransactionStore()
        let categoryStore = CategoryStore()
        let currencyManager = CurrencyManager()
        let toastManager = ToastManager()
        
        // Initialize StateObjects
        _budgetStore = StateObject(wrappedValue: budgetStore)
        _transactionStore = StateObject(wrappedValue: transactionStore)
        _categoryStore = StateObject(wrappedValue: categoryStore)
        _currencyManager = StateObject(wrappedValue: currencyManager)
        _toastManager = StateObject(wrappedValue: toastManager)
        
        // Now create dependent ViewModels
        _budgetManager = StateObject(wrappedValue: BudgetManager(
            budgetStore: budgetStore,
            transactionStore: transactionStore
        ))
        
        _timeSeriesViewModel = StateObject(wrappedValue: TimeSeriesViewModel(
            transactionStore: transactionStore
        ))
        
        _categoryViewModel = StateObject(wrappedValue: CategoryReportViewModel(
            transactionStore: transactionStore
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(categoryStore)
                .environmentObject(transactionStore)
                .environmentObject(currencyManager)
                .environmentObject(budgetStore)
                .environmentObject(budgetManager)
                .environmentObject(toastManager)
                .environmentObject(timeSeriesViewModel)
                .environmentObject(categoryViewModel)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        transactionStore.processRecurringTransactions()
                    }
                }
        }
    }
}
