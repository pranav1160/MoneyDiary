//
//  ToolBarButton.swift
//  MoneyDiary
//
//  Created by Pranav on 15/01/26.
//
import SwiftUI

struct ToolBarCapsuleButton: View {
    
    let title: String?
    let systemImage: String?
    let action: () -> Void
    
    init(
        title: String? = nil,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.subheadline)
                }
                
                if let title {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.accentColor)
            )
            .shadow(
                color: .black.opacity(0.2),
                radius: 3,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(ToolbarButtonStyle())
    }
}


#Preview {
    VStack(spacing:40){
        ToolBarCapsuleButton(systemImage: "plus") {
            print("Add tapped")
        }

        ToolBarCapsuleButton(
            title: "Add",
            systemImage: "plus"
        ) {
            print("Add tapped")
        }

        ToolBarCapsuleButton(title: "Save") {
            print("Save tapped")
        }

    }
}
