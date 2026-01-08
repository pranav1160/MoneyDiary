//
//  BudgetAlert.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

import Foundation
// MARK: - Budget Alert

struct BudgetAlert: Identifiable {
    let id = UUID()
    let budget: Budget
    let severity: Severity
    let message: String
    
    enum Severity {
        case info
        case warning
        case critical
    }
}

