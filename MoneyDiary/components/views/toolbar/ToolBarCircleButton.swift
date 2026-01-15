//
//  ToolBarCircleView.swift
//  MoneyDiary
//
//  Created by Pranav on 15/01/26.
//

import SwiftUI

struct ToolBarCircleButton: View {
    
    let systemImage: String
    let action: () -> Void
    
    init(
        systemImage: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.action = action
    }
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        } label: {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.accentColor)
                )
                .shadow(
                    color: .black.opacity(0.25),
                    radius: 3,
                    x: 0,
                    y: 2
                )
        }
        .buttonStyle(ToolbarButtonStyle())
    }
}


#Preview {
    HStack(spacing: 16) {
        ToolBarCircleButton(systemImage: "plus") {}
        ToolBarCircleButton(systemImage: "trash") {}
        ToolBarCircleButton(systemImage: "pencil") {}
    }
    .padding()
}
