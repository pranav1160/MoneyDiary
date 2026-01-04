//
//  CurrencyPickerView.swift
//  MoneyDiary
//
//  Created by Pranav on 05/01/26.
//
import SwiftUI

struct CurrencyPickerView: View {
    
    @State private var selectedCode = "INR"
    let sortedCurrencies = UICurrency.mockCurrencies.sorted { $0.name < $1.name }

    
    var body: some View {
        VStack(spacing: 24) {
            Picker("Currency", selection: $selectedCode) {
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
    CurrencyPickerView()
}
