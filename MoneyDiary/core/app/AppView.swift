//
//  AppView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct AppView: View {
    @State private var appState = AppState()
    @State private var toast: Toast?
    var body: some View {
        AppViewBuilder(
            showTabBar: appState.showTabBar,
            tabBarView: {
                TabBarView(
                    showToast: { toast = $0 }
                )
            },
            onBoardingView: {
                NavigationStack{
                    WelcomeView()
                }
            }
        )
        .environment(appState)
        .toast($toast)
    }
}

#Preview {
    AppView()
        .withPreviewEnvironment()
}
