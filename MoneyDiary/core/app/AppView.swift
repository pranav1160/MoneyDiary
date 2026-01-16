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
    AppView()
        .withPreviewEnvironment()
}
