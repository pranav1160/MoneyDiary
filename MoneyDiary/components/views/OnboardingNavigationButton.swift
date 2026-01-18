//
//  OnboardingNavigationButton.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//

import SwiftUI

struct OnboardingNavigationButton<Destination: View>: View {
    
    let title: String
    @ViewBuilder let destination: () -> Destination
    
    var body: some View {
        NavigationLink {
            destination()
        } label: {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
    }
}

#Preview {
    OnboardingNavigationButton(title: "hello") {
    }
}
