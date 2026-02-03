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
        let transactionStore = TransactionStore(context: context)
        let currencyManager = CurrencyManager()
        let budgetStore = BudgetStore(context: context)
        let toastManager = ToastManager()
        let timeSeriesViewModel = TimeSeriesViewModel(
            context: context
        )
        let categoryreportViewModel = CategoryReportViewModel(
            context: context
        )
        
        return self
            .modelContainer(container)
            .environmentObject(categoryStore)
            .environmentObject(transactionStore)
            .environmentObject(currencyManager)
            .environmentObject(budgetStore)
            .environmentObject(toastManager)
            .environmentObject(timeSeriesViewModel)
            .environmentObject(categoryreportViewModel)
    }
}
#endif

extension Preview {
    
    static let app: Preview = {
        let preview = Preview(
            Category.self,
            Budget.self,
            Transaction.self
        )
        
        preview.addSamples(
            categories: Category.mockCategories,
            budgets: Budget.mockBudgets,
            transactions: Transaction.mocks
        )
        
        return preview
    }()
}
