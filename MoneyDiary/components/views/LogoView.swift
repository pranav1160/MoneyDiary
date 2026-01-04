//
//  OnboardingLogoView.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image(.mainlogo)
            .resizable()
            .frame(width: 200,height: 200)
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    LogoView()
}
