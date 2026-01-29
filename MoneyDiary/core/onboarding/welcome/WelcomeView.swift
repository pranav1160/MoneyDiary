//
//  WelcomeView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct WelcomeView: View {
    @State private var path: [OnboardingRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 24) {
                
                Spacer()
                
                LogoView(size: 200)
                
                // App Name
                Text("MoneyDiary")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Welcome")
                    .font(.title2)
                    .foregroundStyle(.accent)
                
                Text("Know where your money goes — effortlessly.")
                    .font(.body)
                    .foregroundStyle(.appSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Spacer()
                
                CallToActionButton(title: "Continue") {
                    path.append(.privacy)
                }
            }
            .hideSystemNavigation()
            .navigationDestination(for: OnboardingRoute.self) { route in
                switch route {
                case .privacy:
                    OnboardingPrivacyView(path: $path)
                case .categories:
                    OnboardingListCategoryView(path: $path)
                case .currency:
                    OnboardingCurrencySelectView(path: $path)
                case .completed:
                    OnboardingCompleteView()
                }
            }
        }
    }
}


#Preview {
    
        WelcomeView()
            .environment(AppState())
  
}
