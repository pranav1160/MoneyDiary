//
//  BudgetProgressBar.swift
//  MoneyDiary
//
//  Created by Pranav on 13/01/26.
//
import SwiftUI

struct BudgetProgressBar: View {
    var progress: Double      // 0...100
    var barColor: Color
    var height: CGFloat = 10
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                
                // Background track
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                
                // Progress fill
                Capsule()
                    .fill(barColor)
                    .frame(
                        width: geo.size.width * CGFloat(min(progress, 100) / 100),
                        height: height
                    )
                    .animation(.easeInOut(duration: 0.4), value: progress)
            }
        }
        .frame(height: height)
    }
}
