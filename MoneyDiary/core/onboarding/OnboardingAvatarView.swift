//
//  OnboardingAvatarView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct OnboardingAvatarView: View {
    var body: some View {
        ZStack {
            Image("3onboard")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                NavigationLink {
                    OnboardingCompleteView()
                } label: {
                    Image(systemName: "arrowshape.right.circle.fill")
                }
                .scaleEffect(3)
            }
        }
    }
}

#Preview {
    OnboardingAvatarView()
        .environment(AppState())
}
