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
        VStack(alignment:.leading){
            
            VStack(alignment:.leading){
                HStack{
                    Text(emoji)
                    Text(budget.name)
                    
                }
                .font(.title3)
                .fontWeight(.medium)
                
                Text("\(status.daysRemaining) days left")
                    .font(.default)
                    .foregroundStyle(.appSecondary)
            }
            .padding(.bottom,10)
            
            Text("\(Int(status.percentageUsed))% SPENT")
                .foregroundStyle(colorForStatus)
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.bottom,6)
            
            VStack{
                HStack{
                    Text(currencySymbol)
                        .font(.title2)
                        .foregroundStyle(.appSecondary)
                    
                    Text("\(amountLeft)")
                        .font(.largeTitle)
                }
                
                Text("left this month")
                    .foregroundStyle(.appSecondary)
            }
            
            BudgetProgressBar(
                progress: progressValue,
                barColor: statusBarColor.color,
                height: 30
            )
            .padding(.top, 6)
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
}
