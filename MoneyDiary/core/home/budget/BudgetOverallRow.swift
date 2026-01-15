//
//  BudgetOverallRow.swift
//  MoneyDiary
//
//  Created by Pranav on 14/01/26.
//

import SwiftUI

struct BudgetOverallRow: View {
    
    let currencySymbol: String
    let status: BudgetStatus
    
    
    var body: some View {
        VStack{
            SemiCircleProgressView(
                strokeColor: strokeColor,
                inputVal: status.spent,
                totalVal: status.budget.amount,
                currencySymbol: currencySymbol,
                amountToShow: status.remaining,
                size: 240,
                strokeWidth: 24
            )
            .padding(.top,60)
            .padding(.bottom,-30)
            
            
            VStack{
                // Status info
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "chart.pie.fill")
                            .font(.caption)
                        Text("\(Int(status.percentageUsed))% used")
                            .font(.callout)
                            .fontWeight(.medium)
                    }
                    
                    Circle()
                        .fill(.secondary.opacity(0.5))
                        .frame(width: 4, height: 4)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text("\(status.daysRemaining) days left")
                            .font(.callout)
                            .fontWeight(.medium)
                    }
                }
                .foregroundStyle(.black)
            }
        }
        
       
    }
    
    private var strokeColor: Color {
        return Color.primary.opacity(0.9)
    }
}

#Preview {
    ScrollView{
        BudgetOverallRow(
            currencySymbol: "₹",
            status: BudgetStatus.mockHealthy
        )
        .padding(.top,50)
        
      
    }
}
