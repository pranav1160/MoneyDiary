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
    
    @StateObject private var transactionStore = TransactionStore()
    @StateObject private var currencyManager = CurrencyManager()
    @StateObject private var budgetStore = BudgetStore()
    @StateObject private var toastManager = ToastManager()
    
    // ViewModels (created once)
    @StateObject private var budgetManager: BudgetManager
    @StateObject private var timeSeriesViewModel: TimeSeriesViewModel
    @StateObject private var categoryReportViewModel: CategoryReportViewModel
    
    init() {
        let transactionStore = TransactionStore()
        let budgetStore = BudgetStore()
        
        _transactionStore = StateObject(wrappedValue: transactionStore)
        _budgetStore = StateObject(wrappedValue: budgetStore)
        _currencyManager = StateObject(wrappedValue: CurrencyManager())
        _toastManager = StateObject(wrappedValue: ToastManager())
        
        _budgetManager = StateObject(wrappedValue: BudgetManager(
            budgetStore: budgetStore,
            transactionStore: transactionStore
        ))
        
        _timeSeriesViewModel = StateObject(wrappedValue: TimeSeriesViewModel(
            transactionStore: transactionStore
        ))
        
        _categoryReportViewModel = StateObject(wrappedValue: CategoryReportViewModel(
            transactionStore: transactionStore
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(transactionStore)
                .environmentObject(currencyManager)
                .environmentObject(budgetStore)
                .environmentObject(budgetManager)
                .environmentObject(toastManager)
                .environmentObject(timeSeriesViewModel)
                .environmentObject(categoryReportViewModel)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        transactionStore.processRecurringTransactions()
                    }
                }
        }
        .modelContainer(for: Category.self)
    }
}
