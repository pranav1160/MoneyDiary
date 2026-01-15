//
//  Binding+EXT.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//
import Foundation
import SwiftUI


extension Binding where Value == Double {
    func toString(
        formatter: NumberFormatter = NumberFormatter.decimal
    ) -> Binding<String> {
        Binding<String>(
            get: {
                formatter.string(from: NSNumber(value: wrappedValue)) ?? ""
            },
            set: { newValue in
                if let number = formatter.number(from: newValue) {
                    wrappedValue = number.doubleValue
                }
            }
        )
    }
}


extension Binding where Value==Bool{
    init<T:Sendable>(ifNotNil value:Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
