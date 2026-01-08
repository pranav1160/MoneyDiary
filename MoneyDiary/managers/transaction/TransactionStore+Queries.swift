//
//  TransactionStore+Queries.swift
//  MoneyDiary
//
//  Created by Pranav on 08/01/26.
//

extension TransactionStore {
    
    func total(for type: TransactionType) -> Double {
        transactions
            .filter { $0.transactionType == type }
            .map { $0.amount }
            .reduce(0, +)
    }
}
