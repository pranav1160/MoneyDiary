//
//  EmojiPickerView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//

import SwiftUI
import ElegantEmojiPicker


struct EmojiPickerView: View {
    @Binding var selectedColor:CategoryColor
    @State private var isEmojiPickerPresented = false
    @State private var selectedEmoji: Emoji? = nil
    
    var body: some View {
        VStack {
            Circle()
                .fill(selectedColor.color)
                .frame(width: 90, height: 90)
                .overlay(
                    Text(selectedEmoji?.emoji ?? "👽")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                )
            
            Button {
                isEmojiPickerPresented.toggle()
            } label: {
                Image(systemName: "pencil")
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            

        }
        .emojiPicker(
            isPresented: $isEmojiPickerPresented,
            selectedEmoji: $selectedEmoji,
            detents: [.medium]
        )
    }
}

#Preview {
    EmojiPickerView(selectedColor: .constant(.green))
}
