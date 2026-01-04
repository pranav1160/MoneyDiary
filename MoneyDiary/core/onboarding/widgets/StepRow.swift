//
//  StepRow.swift
//  MoneyDiary
//
//  Created by Pranav on 05/01/26.
//
import SwiftUI

struct StepRow: View {
    let index: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(index)")
                .font(.headline)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.accentColor))
            
            Text(text)
                .font(.body)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .foregroundStyle(.appSecondary)
    }
}
