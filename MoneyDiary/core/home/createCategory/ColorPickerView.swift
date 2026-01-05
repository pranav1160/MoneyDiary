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
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(CategoryColor.allCases) { item in
                Circle()
                    .fill(item.color)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: selectedColor == item ? 4 : 0)
                    )
                    .onTapGesture {
                        selectedColor = item
                    }
                    .animation(.easeInOut(duration: 0.15), value: selectedColor)
            }
        }
        .padding()
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant(.black))
}
