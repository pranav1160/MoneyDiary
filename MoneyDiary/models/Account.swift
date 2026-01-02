//
//  Account.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation
import SwiftUI


struct Account: Identifiable {
    let id: UUID
    let name: String
    let accountNumber: String?
    let balance: Double
    let color: Color
    let type: AccountType
}


enum AccountType {
    case cash
    case bank
    case creditCard
    case wallet
}

extension Account {
    static let mockAccounts: [Account] = [
        Account(
            id: UUID(),
            name: "Cash",
            accountNumber: nil,
            balance: 4200,
            color: .green,
            type: .cash
        ),
        
        Account(
            id: UUID(),
            name: "HDFC Bank",
            accountNumber: "XXXX 4321",
            balance: 18500,
            color: .blue,
            type: .bank
        ),
        
        Account(
            id: UUID(),
            name: "Paytm Wallet",
            accountNumber: "paytm@upi",
            balance: 2300,
            color: .purple,
            type: .wallet
        )
    ]
}
