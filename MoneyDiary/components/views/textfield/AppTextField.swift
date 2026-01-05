//
//  GlassTextField.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//
import SwiftUI
struct AppTextField: View {

    let title: String
    @Binding var text: String

    var systemImage: String? = nil
    var isSecure: Bool = false
    var isDisabled: Bool = false
    var keyboardType: UIKeyboardType = .default

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {

            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
            }

            Group {
                if isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .keyboardType(keyboardType)
            .focused($isFocused)
            .disabled(isDisabled)
        }
        .padding()
        .background {
            GlassBackground()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isFocused ? Color.accentColor : .clear,
                            lineWidth: 1.5
                        )
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    VStack{
        VStack(spacing: 20) {
            
            AppTextField(
                title: "Email",
                text: .constant(""),
                systemImage: "envelope",
                keyboardType: .emailAddress
            )
            
            AppTextField(
                title: "Password",
                text: .constant(""),
                systemImage: "lock",
                isSecure: true
            )
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.black, .gray],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
