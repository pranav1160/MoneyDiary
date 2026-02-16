//
//  CurrencyInfoView.swift
//  MoneyDiary
//
//  Created by Pranav on 16/02/26.
//


import SwiftUI


struct CurrencyInfoView: View {
    
    var body: some View {
        VStack {
            
            // MARK: - Currency Picker
            CurrencyPickerView()
            
            // MARK: - MVP Note
            Section {
                Text(
                    "Changing the currency only affects how amounts are displayed. "
                    + "No conversion is applied — for example, ₹10 will be shown as $10."
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
        }
        .navigationTitle("Currency")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    
    let preview = Preview(Category.self, Budget.self)
    preview.addSamples(
        categories: Category.mockCategories,
        budgets: Budget.mockBudgets
    )
    
    return  CurrencyInfoView()
        .withPreviewEnvironment(container: preview.container)
    
}
