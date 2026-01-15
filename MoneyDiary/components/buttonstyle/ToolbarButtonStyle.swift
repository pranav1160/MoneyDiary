//
//  CircleToolbarButtonStyle.swift
//  MoneyDiary
//
//  Created by Pranav on 15/01/26.
//
import SwiftUI

struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.12 : 1.0)
            .shadow(
                color: .black.opacity(configuration.isPressed ? 0.35 : 0.25),
                radius: configuration.isPressed ? 6 : 3,
                x: 0,
                y: configuration.isPressed ? 4 : 2
            )
            .animation(
                .spring(response: 0.25, dampingFraction: 0.55),
                value: configuration.isPressed
            )
    }
}
