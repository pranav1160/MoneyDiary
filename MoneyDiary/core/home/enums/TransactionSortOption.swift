//
//  TransactionSortOption.swift
//  MoneyDiary
//
//  Created by Pranav on 26/01/26.
//
import Foundation

enum TransactionSortOption: String, CaseIterable, Identifiable {
    case day = "By Day"
    case week = "By Week"
    case month = "By Month"
    case category = "By Category"
    

    var id: String { rawValue }
}
