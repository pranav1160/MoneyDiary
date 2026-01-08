//
//  AmountDialPadView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//


import SwiftUI

struct AmountDialPadView: View {

    @State private var amount: String = ""
    @State private var navigateToExpenseAddView:Bool = false
    @EnvironmentObject private var currencyManager:CurrencyManager
    private let buttons: [[String]] = [
        ["1","2","3"],
        ["4","5","6"],
        ["7","8","9"],
        [".","0","delete"]
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {

                // Close button
                HStack {
                    Spacer()
                    Button {
                        // dismiss
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Amount
                Text("\(currencySymbol)\(amount)")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(.green)

                Spacer()

                // Keypad
                VStack(spacing: 20) {
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 40) {
                            ForEach(row, id: \.self) { item in
                                dialButton(item)
                            }
                        }
                    }
                }

                Spacer()

                // Continue button
                Button {
                    print("Continue with amount \(amount)")
                    navigateToExpenseAddView = true
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .clipShape(Capsule())
                }
                .padding(.horizontal)

            }
            .padding(.vertical)
        }
        .navigationDestination(
            isPresented: $navigateToExpenseAddView) {
                TransactionAddView(amount: amount)
            }
    }
    
    private var currencySymbol:String{
        return currencyManager.selectedCurrency.symbol
    }

    // MARK: - Dial Button
    @ViewBuilder
    private func dialButton(_ value: String) -> some View {
        Button {
            handleTap(value)
        } label: {
            if value == "delete" {
                Image(systemName: "delete.left")
                    .font(.system(size: 22))
                    .foregroundStyle(.white)
            } else {
                Text(value)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 60, height: 60)
    }

    // MARK: - Logic
    private func handleTap(_ value: String) {
        switch value {
        case "delete":
            if !amount.isEmpty {
                amount.removeLast()
            }
        case ".":
            if !amount.contains(".") {
                amount.append(".")
            }
        default:
            amount.append(value)
        }
    }
}

#Preview {
    AmountDialPadView()
}
