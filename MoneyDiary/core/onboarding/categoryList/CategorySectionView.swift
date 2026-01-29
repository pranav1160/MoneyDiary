//
//  CategorySectionView.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//
import Foundation
import SwiftUI

struct CategorySectionView: View {
    
    let title: String
    let color: Color
    let items: [CategoryDraft]
    
    @Binding var selectedIds: Set<UUID>
    
    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text(title)
                .font(.headline)
                .foregroundStyle(color)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(items) { item in
                    CategoryChipView(
                        item: item,
                        isSelected: Binding(
                            get: {
                                selectedIds.contains(item.id)
                            },
                            set: { newValue in
                                if newValue {
                                    selectedIds.insert(item.id)
                                } else {
                                    selectedIds.remove(item.id)
                                }
                            }
                        )
                        )
                }
            }
        }
    }
}


