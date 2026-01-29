//
//  Preview+EXT.swift
//  MoneyDiary
//
//  Created by Pranav on 14/01/26.
//

import SwiftUI
import SwiftData

#if DEBUG
extension View {
    /// Injects all EnvironmentObjects needed for MoneyDiary previews
    @MainActor
    func withPreviewEnvironment(container: ModelContainer) -> some View {
        let context = container.mainContext
        
        let categoryStore = CategoryStore(context: context)
        let transactionStore = TransactionStore()
        let currencyManager = CurrencyManager()
        let budgetStore = BudgetStore(context: context)
        let toastManager = ToastManager()
        let budgetManager = BudgetManager(
            budgetStore: budgetStore,
            transactionStore: transactionStore
        )
        let timeSeriesViewModel = TimeSeriesViewModel(
            transactionStore: transactionStore
        )
        let categoryreportViewModel = CategoryReportViewModel(
            transactionStore: transactionStore
        )
        
        return self
            .modelContainer(container)
            .environmentObject(categoryStore)
            .environmentObject(transactionStore)
            .environmentObject(currencyManager)
            .environmentObject(budgetStore)
            .environmentObject(budgetManager)
            .environmentObject(toastManager)
            .environmentObject(timeSeriesViewModel)
            .environmentObject(categoryreportViewModel)
    }
}
#endif
