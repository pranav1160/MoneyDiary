//
//  CurrencyManager.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//
import Foundation
import Combine

@MainActor
final class CurrencyManager: ObservableObject {
    
    private let currencyKey = "selected_currency_code"
    
    @Published var selectedCurrency: Currency {
        didSet {
            UserDefaults.standard.set(selectedCurrency.code, forKey: currencyKey)
        }
    }
    
    init() {
        let savedCode = UserDefaults.standard.string(forKey: currencyKey) ?? "INR"
        self.selectedCurrency =
            Currency.mockCurrencies.first { $0.code == savedCode }
            ?? .mockCurrencies.first!
    }
}
