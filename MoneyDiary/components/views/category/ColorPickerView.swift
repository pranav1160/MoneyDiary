//
//  ColorPickerView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var selectedColor: CategoryColor
    
    private let columns = [
        GridItem(.adaptive(minimum: 70), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(CategoryColor.allCases) { item in
                ColorCircleButton(
                    color: item,
                    isSelected: selectedColor == item
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedColor = item
                    }
                }
            }
        }
        .padding()
    }
}


#Preview {
    ColorPickerView(selectedColor: .constant(.blue))
}
