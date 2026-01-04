//
//  CategoryChip.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//
import Foundation
import SwiftUI

struct CategoryChipView: View {
    
    let item: CategoryItem
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Text(item.emoji)
            Text(item.title)
                .font(.subheadline)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.4), lineWidth: 1)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
                )
        )
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

