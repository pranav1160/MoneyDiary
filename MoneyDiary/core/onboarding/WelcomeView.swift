//
//  WelcomeView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI



struct WelcomeView: View {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                Spacer()
                
                LogoView()
                
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
                
                OnboardingNavigationButton(title: "Get Started") {
                    OnboardingPrivacyView()
                }

            }
            
        }
    }
}


#Preview {
    
        WelcomeView()
            .environment(AppState())
  
}
