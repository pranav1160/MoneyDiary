//
//  TransactionRoute.swift
//  MoneyDiary
//
//  Created by Pranav on 14/01/26.
//
import Foundation

enum TransactionRoute: Hashable {
    case amount
    case create(amount: String)
    case editAmount(transactionId: UUID)
    case edit(transactionId: UUID, amount: String)
}
