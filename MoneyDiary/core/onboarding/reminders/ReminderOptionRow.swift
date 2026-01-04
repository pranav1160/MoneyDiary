//
//  ReminderOptionRow.swift
//  MoneyDiary
//
//  Created by Pranav on 05/01/26.
//
import SwiftUI

struct ReminderOptionRow: View {
    
    let option: ReminderOption
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            
            Text(option.emoji)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.white.opacity(0.08)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(option.title)
                    .font(.headline)
                
                Text(option.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.appSecondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(radius: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    isSelected ? Color.blue : Color.clear,
                    lineWidth: 2
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

