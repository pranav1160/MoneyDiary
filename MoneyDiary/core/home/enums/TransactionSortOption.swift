//
//  TransactionSortOption.swift
//  MoneyDiary
//
//  Created by Pranav on 26/01/26.
//
import Foundation

enum TransactionSortOption: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case category = "Category"
    

    var id: String { rawValue }
}
