//
//  BudgetCategoryRow.swift
//  MoneyDiary
//
//  Created by Pranav on 13/01/26.
//

import SwiftUI

struct BudgetCategoryRow: View {
    let currencySymbol:String
    let budget: Budget
    let emoji: String
    let status: BudgetStatus
    let statusBarColor:CategoryColor
    let title:String
    
    var body: some View {
        HStack{
                VStack(alignment:.leading){
                    HStack{
                        Text(emoji)
                        
                        Text(title)
                        
                    }
                    .font(.title3)
                    .fontWeight(.medium)
                    
                    Text("\(status.daysRemaining) days left")
                        .font(.caption)
                        .foregroundStyle(.appSecondary)
                    
                    
                    BudgetStatusCapsules(status: status.status)
                }
            
            Spacer()
            
            AnimatedRoundedRectProgress(
                strokeColor: statusBarColor.color,
                inputVal: status.spent,
                totalVal: budget.amount,
                size: CGSize(width: 80, height: 50),
                strokeWidth: 8,
                cornerRadius: 15,
                symbol: currencySymbol
            )
           
        }
        
        
    }
    
    private var amountLeft:Int{
        return Int(budget.amount - status.spent)
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

import SwiftUI

struct BudgetStatusCapsules: View {
    let status: BudgetStatus.Status
    
    private let totalCapsules = 4
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalCapsules, id: \.self) { index in
                Capsule()
                    .fill(capsuleColor(at: index))
                    .frame(width: 16, height: 3)
            }
        }
    }
    
    private func capsuleColor(at index: Int) -> Color {
        index < filledCount
        ? activeColor
        : .appSecondary.opacity(0.3)
    }
    
    private var filledCount: Int {
        switch status {
        case .healthy:
            return 4
        case .caution:
            return 3
        case .warning:
            return 2
        case .overBudget:
            return 1
        }
    }
    
    private var activeColor: Color {
        switch status {
        case .healthy:
            return .green
        case .caution:
            return .yellow
        case .warning:
            return .orange
        case .overBudget:
            return .red
        }
    }
}


#Preview {
    List{
        BudgetCategoryRow(
            currencySymbol: "₹",
            budget: BudgetStatus.mockHealthy.budget,
            emoji: "🛒",
            status: .mockHealthy,
            statusBarColor: CategoryColor.green, title: "hello"
        )
        
        BudgetCategoryRow(
            currencySymbol: "₹",
            budget: BudgetStatus.mockCaution.budget,
            emoji: "🛒",
            status: .mockCaution,
            statusBarColor: CategoryColor.green, title: "hello"
        )
        
        BudgetCategoryRow(
            currencySymbol: "₹",
            budget: BudgetStatus.mockWarning.budget,
            emoji: "🛒",
            status: .mockWarning,
            statusBarColor: CategoryColor.green, title: "hello"
        )
        
        BudgetCategoryRow(
            currencySymbol: "₹",
            budget: BudgetStatus.mockOverBudget.budget,
            emoji: "🛒",
            status: .mockOverBudget,
            statusBarColor: CategoryColor.green, title: "hello"
        )
        
        
    }

    .padding()
}
