//
//  TimeSeriesViewModel.swift
//  MoneyDiary
//
//  Created by Pranav on 24/01/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class TimeSeriesViewModel: ObservableObject {
    
    @Published private(set) var daily: [TimeSeriesPoint] = []
    @Published private(set) var weekly: [TimeSeriesPoint] = []
    @Published private(set) var monthly: [TimeSeriesPoint] = []
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        recomputeAll()
    }
    
    func recomputeAll() {
        let analytics = TransactionAnalytics(context: context)
        let calendar = Calendar.current
        
        daily = analytics.dailyTotals(
            from: calendar.date(byAdding: .day, value: -6, to: .now)!
        )
        
        weekly = analytics.weeklyTotals(weeks: 4)
        monthly = analytics.monthlyTotals(months: 6)
    }
}
