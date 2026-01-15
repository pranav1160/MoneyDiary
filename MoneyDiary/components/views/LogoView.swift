//
//  OnboardingLogoView.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//

import SwiftUI

struct LogoView: View {
    let size:CGFloat
    var body: some View {
        Image(.mainlogo)
            .resizable()
            .frame(width: size,height: size)
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    LogoView(size: 200)
}
