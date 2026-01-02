//
//  SummaryColumn.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import SwiftUI

struct SummaryColumn: View {
    let title: String
    let amount: String
    let percent: Double
    let percentColor: Color
    @Binding var isBalanceHidden:Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
            
            HStack(spacing: 6) {
                Text(isBalanceHidden ? "••••" : amount)
                
                Text("↑ \(String(format: "%.2f", percent))%")
                    .foregroundColor(percentColor)
            }
            
            Text("Compared to last month")
                .font(.caption)
                .foregroundStyle(.black.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

