//
//  CategoryReportViewModel.swift
//  MoneyDiary
//
//  Created by Pranav on 25/01/26.
//


import Foundation
import Combine

@MainActor
final class CategoryReportViewModel: ObservableObject {
    
    @Published var selectedPeriod: CategoryReportPeriod = .last7Days {
        didSet { reload() }
    }
    
    @Published private(set) var data: [[CategoryAggregate]] = []
    
    private let transactionStore: TransactionStore
    
    init(transactionStore: TransactionStore) {
        self.transactionStore = transactionStore
        reload()
    }
    
    private func reload() {
        switch selectedPeriod {
        case .last7Days:
            data = [transactionStore.topCategoriesLast7Days()]
        case .last4Weeks:
            data = transactionStore.topCategoriesLast4Weeks()
        case .last6Months:
            data = transactionStore.topCategoriesLast6Months()
        }
    }
}

