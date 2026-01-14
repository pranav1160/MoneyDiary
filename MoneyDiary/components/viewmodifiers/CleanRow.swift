//
//  CleanRow.swift
//  MoneyDiary
//
//  Created by Pranav on 14/01/26.
//
import SwiftUI

struct CleanRow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

extension View {
    func cleanRow() -> some View {
        self.modifier(CleanRow())
    }
}
