//
//  GlassBackground.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//
import SwiftUI

struct GlassBackground: View {
    var cornerRadius: CGFloat = 16
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.25), lineWidth: 1)
            )
    }
}
