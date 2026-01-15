//
//  AmountDialPadView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//

import SwiftUI

struct AmountDialPadView: View {
    
    let onContinue: (String) -> Void
    @State private var amount: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var currencyManager: CurrencyManager
    
    private let buttons: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "delete"]
    ]
    
    init(
        initialAmount: String = "",
        onContinue: @escaping (String) -> Void
    ) {
        self.onContinue = onContinue
        _amount = State(initialValue: initialAmount)
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "0f0f1e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Text("Enter Amount")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white.opacity(0.6))
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 20)
                
                Spacer(minLength: 40)
                
                // Amount display with animation
                HStack(spacing: 8) {
                    Text(currencySymbol)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Text(displayAmount)
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(amountColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .contentTransition(.numericText())
                        .animation(.snappy(duration: 0.2), value: amount)

                }
                .padding(.horizontal, 32)
                
                Spacer(minLength: 60)
                
                // Keypad
                VStack(spacing: 16) {
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 24) {
                            ForEach(row, id: \.self) { item in
                                dialButton(item)
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer(minLength: 40)
                
                // Continue button
                CallToActionButton(
                    title: "Continue",
                    action: {
                        onContinue(amount)
                    },
                    isDisabled: !isValidAmount
                )
                .shadow(
                    color: isValidAmount ? Color(hex: "4ade80").opacity(0.3) : Color.clear,
                    radius: 20,
                    y: 10
                )
                
                
                .animation(.easeInOut(duration: 0.2), value: isValidAmount)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        
    }
    
    // MARK: - Computed Properties
    
    private var currencySymbol: String {
        currencyManager.selectedCurrency.symbol
    }
    
    private var displayAmount: String {
        amount.isEmpty ? "0" : amount
    }
    
    private var amountColor: Color {
        if amount.isEmpty {
            return .white.opacity(0.3)
        } else if let value = Double(amount), value > 0 {
            return Color(hex: "4ade80")
        } else {
            return .white
        }
    }
    
    private var isValidAmount: Bool {
        guard !amount.isEmpty else { return false }
        guard let value = Double(amount) else { return false }
        return value > 0
    }
    
    // MARK: - Dial Button
    
    @ViewBuilder
    private func dialButton(_ value: String) -> some View {
        let isDotDisabled = value == "." && amount.contains(".")
        
        Button {
            handleTap(value)
        } label: {
            ZStack {
                Circle()
                    .fill(
                        value == "delete"
                        ? Color.red.opacity(0.15)
                        : Color.white.opacity(0.08)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                if value == "delete" {
                    Image(systemName: "delete.left.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.red.opacity(0.9))
                        .onLongPressGesture(minimumDuration: 0.35) {
                            withAnimation(.snappy) {
                                amount = ""
                            }
                        }
                } else {
                    Text(value)
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 75, height: 75)
            .opacity(isDotDisabled ? 0.4 : 1)
        }
        .disabled(isDotDisabled)
        .buttonStyle(DialButtonStyle())
    }


    
    // MARK: - Logic
    
    private func handleTap(_ value: String) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        withAnimation(.snappy(duration: 0.2)) {
            switch value {
            case "delete":
                if !amount.isEmpty {
                    amount.removeLast()
                }
            case ".":
                if !amount.contains(".") {
                    amount = amount.isEmpty ? "0." : amount + "."
                }
                
            default:
                if amount == "0" {
                    amount = value
                    return
                }
                
                if let dotIndex = amount.firstIndex(of: ".") {
                    let decimals = amount[amount.index(after: dotIndex)...]
                    if decimals.count >= 2 { return }
                }
                
                if amount.count < 12 {
                    amount.append(value)
                }


            }
        }
    }
}

// MARK: - Button Style

struct DialButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Color Extension


#Preview {
    AmountDialPadView(onContinue: {_ in })
        .withPreviewEnvironment()
}
