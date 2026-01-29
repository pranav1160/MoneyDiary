//
//  CurrencyPickerView.swift
//  MoneyDiary
//
//  Created by Pranav on 05/01/26.
//
import SwiftUI

struct CurrencyPickerView: View {
    
    @EnvironmentObject private var currencyManager: CurrencyManager
    
    let sortedCurrencies = Currency.mockCurrencies.sorted { $0.name < $1.name }
    
    var body: some View {
        VStack(spacing: 24) {
            Picker(
                "Currency",
                selection: Binding(
                    get: { currencyManager.selectedCurrency.code },
                    set: { newCode in
                        if let currency = Currency.mockCurrencies.first(where: { $0.code == newCode }) {
                            currencyManager.selectedCurrency = currency
                        }
                    }
                )
            ) {
                ForEach(sortedCurrencies) { currency in
                    HStack {
                        Text(currency.flag)
                        Text(currency.name)
                        Spacer()
                        Text(currency.symbol)
                    }
                    .tag(currency.code)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 220)
            .clipped()
        }
        .padding()
        .navigationTitle("Currency")
    }
}


#Preview {
    let container = {
        let preview = Preview(Category.self)
        preview.addSamples(Category.mockCategories)
        return preview.container
    }()
    CurrencyPickerView()
        .withPreviewEnvironment(container: container)
}
