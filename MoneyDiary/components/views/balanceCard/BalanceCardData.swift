//
//  BalanceCardData.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//


struct BalanceCardData {
    let totalBalance: Double
    let income: Double
    let incomeChangePercent: Double
    let expense: Double
    let expenseChangePercent: Double
    let currencySymbol: String
}


extension BalanceCardData {
    
    static let mock = BalanceCardData(
        totalBalance: 12500,
        income: 30000,
        incomeChangePercent: 12.5,
        expense: 17500,
        expenseChangePercent: 8.2,
        currencySymbol: "₹"
    )
}
