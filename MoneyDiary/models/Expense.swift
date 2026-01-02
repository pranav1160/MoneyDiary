//
//  Expense.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation

struct Expense: Identifiable {
    let id: UUID
    let title: String
    let amount: Double
    let date: Date
    let categoryId: UUID
    let accountId: UUID
    let isRecurring: Bool
}
