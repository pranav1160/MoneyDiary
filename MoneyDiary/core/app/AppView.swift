//
//  AppView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct AppView: View {
    @State private var appState = AppState()
    var body: some View {
        AppViewBuilder(
            showTabBar: appState.showTabBar,
            tabBarView: {
                TabBarView()
            },
            onBoardingView: {
                NavigationStack{
                    WelcomeView()
                }
            }
        )
        .environment(appState)
    }
}

#Preview {
    let preview = Preview(Category.self, Budget.self)
    preview.addSamples(
        categories: Category.mockCategories,
        budgets: Budget.mockBudgets
    )
    
    return AppView()
        .withPreviewEnvironment(container: preview.container)
}

