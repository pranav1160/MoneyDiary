//
//  GlassAmountField.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//
import SwiftUI

struct AppNumericField: View {

    let title: String
    @Binding var value: Double

    var body: some View {
        AppTextField(
            title: title,
            text: $value.toString(),
            systemImage: "indianrupeesign.circle"
        )
        .keyboardType(.decimalPad)
    }
}
