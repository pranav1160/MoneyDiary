//
//  Expense.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation

struct Transaction: Identifiable {
    let id: UUID
    let title: String
    let amount: Double
    let date: Date
    let transactionType: TransactionType
    let isRecurring: Bool
    let categoryId: UUID
}


enum TransactionType:String, CaseIterable{
    case expense = "Expense"
    case income = "Income"
}
