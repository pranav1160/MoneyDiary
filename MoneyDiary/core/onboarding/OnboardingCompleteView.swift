//
//  OnboardingCompleteView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct OnboardingCompleteView: View {
    @Environment(AppState.self) private var appstate
    @State private var isProfileSetupFinishing:Bool = false
    var body: some View {
        ZStack {
            Image("4onboard")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Button {
                    onFinishButtonPressed()
                } label: {
                    Image(systemName: "arrowshape.right.circle.fill")
                }
                .scaleEffect(3)
            }
        }
    }
    
    private func onFinishButtonPressed(){
        isProfileSetupFinishing = true
        Task{
            try await Task.sleep(for: .seconds(2))
            isProfileSetupFinishing = false
            appstate.updateViewState(showTabBarView: true)
        }
    }
}

#Preview {
    OnboardingCompleteView()
        .environment(AppState(showTabBar: true))
}
