//
//  BalanceCardView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import SwiftUI

struct BalanceCardView: View {
    
    let data: BalanceCardData
    @State private var isBalanceHidden: Bool = false
    let backgroundColor: Color
    
    private func format(_ value: Double) -> String {
        "\(data.currencySymbol)\(String(format: "%.2f", value))"
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(backgroundColor)
            
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Top Row
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Total balance")
                            .font(.subheadline)
                        
                        Text(isBalanceHidden ? "••••" : format(data.totalBalance))
                            .font(.system(size: 42, weight: .bold))
                    }
                    
                    Spacer()
                    
                    Button{
                        isBalanceHidden.toggle()
                    }label: {
                        Image(systemName: isBalanceHidden ? "eye" : "eye.slash")

                    }
                }
                
                // MARK: - This Month
                Text("This month")
                    .font(.subheadline)
                
                // MARK: - Income & Expense
                HStack {
                    
                    // Income
                    SummaryColumn(
                        title: "Income",
                        amount: format(data.income),
                        percent: data.incomeChangePercent,
                        percentColor: .green,
                        isBalanceHidden: $isBalanceHidden
                    )
                    
                    Spacer()
                    
                    // Expense
                    SummaryColumn(
                        title: "Expense",
                        amount: format(data.expense),
                        percent: data.expenseChangePercent,
                        percentColor: .red,
                        isBalanceHidden: $isBalanceHidden
                    )
                }
            }
            .padding(24)
            .foregroundStyle(.black)
        }
        .frame(height: 260)
        .padding()
    }
}


#Preview {
    BalanceCardView(data: .mock,backgroundColor: .white)
}
