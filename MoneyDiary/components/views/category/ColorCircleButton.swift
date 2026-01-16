//
//  ColorCircleButton.swift
//  MoneyDiary
//
//  Created by Pranav on 16/01/26.
//
import SwiftUI

struct ColorCircleButton: View {
    let color: CategoryColor
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Shadow circle for depth
            Circle()
                .fill(color.color.opacity(0.3))
                .frame(width: 68, height: 68)
                .blur(radius: isSelected ? 8 : 4)
                .opacity(isSelected ? 1 : 0)
            
            // Main color circle
            Circle()
                .fill(color.color)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .strokeBorder(.white, lineWidth: isSelected ? 3 : 0)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    // Checkmark for selected state
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .opacity(isSelected ? 1 : 0)
                        .scaleEffect(isSelected ? 1 : 0.5)
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .scaleEffect(isSelected ? 1.1 : 1.0)
        }
        .contentShape(Circle())
        .onTapGesture {
            action()
        }
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}


#Preview {
    ColorCircleButton(color: .blue, isSelected: true, action: {
        print("")
    })
}
