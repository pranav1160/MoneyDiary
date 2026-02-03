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
    let container: ModelContainer
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var transactionStore:TransactionStore
    @StateObject private var currencyManager = CurrencyManager()
    @StateObject private var budgetStore:BudgetStore
    @StateObject private var toastManager = ToastManager()
    @StateObject private var categoryStore: CategoryStore
    
    
    // ViewModels (created once)
   
    @StateObject private var timeSeriesViewModel: TimeSeriesViewModel
    @StateObject private var categoryReportViewModel: CategoryReportViewModel
    
    init() {
        let schema = Schema([
            Category.self,Budget.self,Transaction.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            self.container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            // Debug: Print the store URL
            if let storeURL = container.configurations.first?.url {
                print("📁 SwiftData store location: \(storeURL)")
            }
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        
        let context = container.mainContext
        
        let transactionStore = TransactionStore(context: context)
        let budgetStore = BudgetStore(context: context)
        let categoryStore = CategoryStore(context: context)
        
        _categoryStore = StateObject(wrappedValue: categoryStore)
        _transactionStore = StateObject(wrappedValue: transactionStore)
        _budgetStore = StateObject(wrappedValue: budgetStore)
        _currencyManager = StateObject(wrappedValue: CurrencyManager())
        _toastManager = StateObject(wrappedValue: ToastManager())
        
     
        
        _timeSeriesViewModel = StateObject(wrappedValue: TimeSeriesViewModel(
            context: context
        ))
        
        _categoryReportViewModel = StateObject(wrappedValue: CategoryReportViewModel(
            context: context
        ))
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(transactionStore)
                .environmentObject(currencyManager)
                .environmentObject(budgetStore)
                .environmentObject(toastManager)
                .environmentObject(categoryStore)
                .environmentObject(timeSeriesViewModel)
                .environmentObject(categoryReportViewModel)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        transactionStore.processRecurringTransactions()
                    }
                }
        }
        .modelContainer(container)

    }
}
