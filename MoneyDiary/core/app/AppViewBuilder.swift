//
//  AppViewBuilder.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//



import SwiftUI

struct AppViewBuilder<TabBarView: View, OnboardingView: View>: View {
    var showTabBar: Bool
    @ViewBuilder var tabBarView: TabBarView
    @ViewBuilder var onBoardingView: OnboardingView
    var body: some View {
        ZStack {
            if showTabBar {
                tabBarView
                .transition(.move(edge: .trailing))
            } else {
                onBoardingView
                .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabBar)
    }
}

private struct PreviewAppViewBuilder: View {
    @State private var showTabBar = false
    var body: some View {
        ZStack {
            if showTabBar {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    Text("Tab Bar View")
                }
                .transition(.move(edge: .trailing))
            } else {
                ZStack {
                    Color.red.ignoresSafeArea()
                    Text("Onboarding View")
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabBar)
        .onTapGesture {
            showTabBar.toggle()
        }
    }
}
#Preview {
    PreviewAppViewBuilder()
}
