//
//  OnboardingCompleteView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//


import SwiftUI

struct OnboardingCompleteView: View {
    @Environment(AppState.self) private var appstate
    @State private var isProfileSetupFinishing = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            LogoView(size: 200)
                .scaleEffect(isProfileSetupFinishing ? 0.95 : 1)
                .animation(.easeInOut(duration: 0.3), value: isProfileSetupFinishing)
            
            completionMessage
            
            Spacer()
            
            CallToActionButton(
                title: "Finish",
                isLoading: isProfileSetupFinishing
            ) {
                HapticManager.instance.notification(type: .success)
                onFinishButtonPressed()
            }
        }
        .hideSystemNavigation()
        .padding()
    }
}

private extension OnboardingCompleteView {
    var completionMessage: some View {
        VStack(spacing: 12) {
            Text("You're all set! 🎉")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            
            Text("Your MoneyDiary is ready. Start tracking your expenses and build better habits today.")
                .font(.body)
                .foregroundStyle(.appSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

private extension OnboardingCompleteView {
    
    func onFinishButtonPressed() {
        isProfileSetupFinishing = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        Task {
            try await Task.sleep(for: .seconds(1.5))
            isProfileSetupFinishing = false
            appstate.updateViewState(showTabBarView: true)
        }
    }
}



#Preview {
    OnboardingCompleteView()
        .environment(AppState(showTabBar: true))
}
