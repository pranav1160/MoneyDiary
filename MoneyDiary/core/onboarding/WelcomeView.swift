//
//  WelcomeView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Image(._1Onboard)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea() 
            
            VStack {
                Spacer()
                
                NavigationLink {
                    OnboardingAvatarView()
                } label: {
                    Image(systemName: "arrowshape.right.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 40)
            }
        }
    }
}


#Preview {
    WelcomeView()
        .environment(AppState())
}
