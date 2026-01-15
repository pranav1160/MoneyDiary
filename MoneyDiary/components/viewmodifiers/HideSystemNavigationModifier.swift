//
//  HideSystemNavigationModifier.swift
//  MoneyDiary
//
//  Created by Pranav on 15/01/26.
//


import SwiftUI

struct HideSystemNavigationModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
    }
}


extension View {
    func hideSystemNavigation() -> some View {
        modifier(HideSystemNavigationModifier())
    }
}
