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
    
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                
                VStack(alignment:.leading){
                    HStack{
                        Text(emoji)
                        Text(budget.name)
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    
                    Text("\(status.daysRemaining) days left")
                        .font(.subheadline)
                        .foregroundStyle(.appSecondary)
                }
                .padding(.bottom,6)
                
                HStack{
                    Text("\(Int(status.percentageUsed))% SPENT")
                    Text("this month")
                        .foregroundStyle(.appSecondary)
                }
                .foregroundStyle(colorForStatus)
                .font(.subheadline)
                .fontWeight(.semibold)
            }
            
            Spacer()
            
            AnimatedCircleProgress(
                strokeColor: statusBarColor.color,
                inputVal: status.spent,
                totalVal: budget.amount,
                size:80,
                strokeWidth: 8
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

#Preview {
    BudgetCategoryRow(
        currencySymbol: "₹",
        budget: BudgetStatus.mockHealthy.budget,
        emoji: "🛒",
        status: .mockHealthy,
        statusBarColor: CategoryColor.green
    )
//    .frame(maxWidth: .infinity,alignment: .leading)
    .padding()
}
