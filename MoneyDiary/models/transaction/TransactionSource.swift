//
//  TransactionSource.swift
//  MoneyDiary
//
//  Created by Pranav on 17/01/26.
//

import Foundation

enum TransactionSource: String, Codable {
    case manual
    case recurringTemplate
    case recurringGenerated
}
