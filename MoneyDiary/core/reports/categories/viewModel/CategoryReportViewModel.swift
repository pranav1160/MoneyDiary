//
//  CategoryReportViewModel.swift
//  MoneyDiary
//
//  Created by Pranav on 25/01/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class CategoryReportViewModel: ObservableObject {
    
    @Published var selectedPeriod: CategoryReportPeriod = .last7Days {
        didSet { reload() }
    }
    
    @Published private(set) var data: [[CategoryAggregate]] = []
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        reload()
    }
    
     func reload() {
        let analytics = TransactionAnalytics(context: context)
        
        switch selectedPeriod {
        case .last7Days:
            data = [analytics.topCategoriesLast7Days()]
            
        case .last4Weeks:
            data = analytics.topCategoriesLast4Weeks()
            
        case .last6Months:
            data = analytics.topCategoriesLast6Months()
        }
    }
}

