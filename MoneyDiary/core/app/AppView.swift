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
    let container = {
        let preview = Preview(Category.self)
        preview.addSamples(Category.mockCategories)
        return preview.container
    }()
    AppView()
        .withPreviewEnvironment(container: container)
}
