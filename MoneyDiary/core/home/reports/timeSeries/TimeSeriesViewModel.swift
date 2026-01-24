//
//  TimeSeriesViewModel.swift
//  MoneyDiary
//
//  Created by Pranav on 24/01/26.
//


import Foundation
import Combine
import SwiftUI

@MainActor
final class TimeSeriesViewModel: ObservableObject {
    
    @Published private(set) var daily: [TimeSeriesPoint] = []
    @Published private(set) var weekly: [TimeSeriesPoint] = []
    @Published private(set) var monthly: [TimeSeriesPoint] = []
    
    private let transactionStore: TransactionStore
    private var cancellables = Set<AnyCancellable>()
    
    init(transactionStore: TransactionStore) {
        self.transactionStore = transactionStore
        bind()
        recomputeAll()
    }
    
    private func bind() {
        transactionStore.$transactions
            .sink { [weak self] _ in
                self?.recomputeAll()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Recompute
    private func recomputeAll() {
        let calendar = Calendar.current
        print("Recomputing charts at", Date())

        
        daily = transactionStore.dailyTotals(
            from: calendar.date(byAdding: .day, value: -30, to: .now)!
        )
        
        weekly = transactionStore.weeklyTotals(weeks: 4)
        monthly = transactionStore.monthlyTotals(months: 6)
    }
}
