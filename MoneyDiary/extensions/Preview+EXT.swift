//
//  Preview+EXT.swift
//  MoneyDiary
//
//  Created by Pranav on 14/01/26.
//

import SwiftUI

#if DEBUG
extension View {
    
    /// Injects all EnvironmentObjects needed for MoneyDiary previews
    func withPreviewEnvironment() -> some View {
        
        let categoryStore = CategoryStore()
        let transactionStore = TransactionStore()
        let currencyManager = CurrencyManager()
        let budgetStore = BudgetStore()
        let toastManager = ToastManager()
        let budgetManager = BudgetManager(
            budgetStore: budgetStore,
            transactionStore: transactionStore
        )
        
        return self
            .environmentObject(categoryStore)
            .environmentObject(transactionStore)
            .environmentObject(currencyManager)
            .environmentObject(budgetStore)
            .environmentObject(budgetManager)
            .environmentObject(toastManager)
    }
}
#endif


