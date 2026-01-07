//
//  EmojiPickerView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//

import SwiftUI
import ElegantEmojiPicker


struct EmojiPickerView: View {
    @Binding var selectedColor: CategoryColor
    @Binding var selectedEmoji: String
    
    @State private var isEmojiPickerPresented = false
    @State private var internalEmoji: Emoji? = nil

    var body: some View {
        VStack {
            Circle()
                .fill(selectedColor.color)
                .frame(width: 90, height: 90)
                .overlay(
                    Text(selectedEmoji)
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
            selectedEmoji: $internalEmoji,
            detents: [.medium]
        )
        .onChange(of: internalEmoji) { _, newValue in
            if let emoji = newValue {
                selectedEmoji = emoji.emoji
            }
        }
    }

}

#Preview {
    EmojiPickerView(
        selectedColor: .constant(.green),
        selectedEmoji: .constant("🙂")
    )
}
