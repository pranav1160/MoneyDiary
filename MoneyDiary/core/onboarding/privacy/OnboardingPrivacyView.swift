//
//  PrivacyOnboardingView.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//


import SwiftUI

struct OnboardingPrivacyView: View {
    @Binding var path: [OnboardingRoute]
    var body: some View {
        VStack(spacing: 32) {
            
            LogoView(size: 200)
            
            // Icon
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 56))
                .foregroundStyle(.accent)
            
            // Title
            Text("Your Privacy Comes First")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            description
            
            Spacer()
            
            // CTA
            
            CallToActionButton(title: "Continue") {
                path.append(.categories)
            }
            
        }
        .hideSystemNavigation()
        .padding()
    }
    
    private var description: some View{
        // Description
        VStack(spacing: 16) {
            Text("All your expense data is stored only on your device.")
            
            Text("We don’t require an account, and we don’t upload your data to any server.")
            
            Text("You stay fully in control — always.")
        }
        .font(.body)
        .foregroundStyle(.blue)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 24)
        
        
    }
}

#Preview {
    NavigationStack{
        OnboardingPrivacyView (path: .constant([]))
    }
}
