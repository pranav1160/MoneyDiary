//
//  BudgetRow.swift
//  MoneyDiary
//
//  Created by Pranav on 09/01/26.
//


import SwiftUI


struct BudgetRow: View {
    let budget: Budget
    let emoji: String
    let status: BudgetStatus
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(emoji)
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    Text(budget.name)
                        .font(.headline)
                    
                    Text("₹\(Int(status.spent)) / ₹\(Int(budget.amount))")
                        .font(.caption)
                        .foregroundStyle(.appSecondary)
                }
                
                Spacer()
                
                Text("\(Int(status.percentageUsed))%")
                    .foregroundStyle(colorForStatus)
                    .bold()
            }
            
            ProgressView(value: progressValue, total: 100)
                .tint(colorForStatus)


        }
        .padding(.vertical, 6)
    }
    
    private var progressValue: Double {
        min(status.percentageUsed, 100)
    }

    
    private var colorForStatus: Color {
        switch status.status {
        case .healthy: return .green
        case .caution: return .yellow
        case .warning: return .orange
        case .overBudget: return .red
        }
    }
}


#Preview {
    VStack {
        BudgetRow(
            budget: BudgetStatus.mockHealthy.budget,
            emoji: "🛒",
            status: .mockHealthy
        )
        
        BudgetRow(
            budget: BudgetStatus.mockOverBudget.budget,
            emoji: "🛍️",
            status: .mockOverBudget
        )
    }
    .padding()
}
