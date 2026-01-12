//
//  SettingsLabel.swift
//  MoneyDiary
//
//  Created by Pranav on 13/01/26.
//

import SwiftUI

struct SettingsLabel: View {
    let text: String
    let sfIcon: String
    let color: Color
    let indicatorText: String?
    let onTapFunc: () -> Void
    
    var body: some View {
        Button(action: onTapFunc) {
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: sfIcon)
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                
                Text(text)
                    .font(.title3)
                    .fontWeight(.medium)
                
                Spacer()
                
                if let indicatorText {
                    Text(indicatorText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .contentShape(Rectangle()) // full row tappable
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    SettingsLabel(
        text: "iCloud Sync",
        sfIcon: "cloud.fill",
        color: Color.yellow,
        indicatorText: "On",
        onTapFunc: {print("icloud sync tapped")}
    )
}
