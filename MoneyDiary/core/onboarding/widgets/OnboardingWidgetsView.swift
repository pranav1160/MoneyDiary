//
//  OnboardingWidgetsView.swift
//  MoneyDiary
//
//  Created by Pranav on 05/01/26.
//

import SwiftUI

struct OnboardingWidgetsView: View {
    
    @State private var selectedTab: WidgetTab = .home
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                header
                
                widgetPreview
                
                widgetTabPicker
                
                stepsList
                
                
            }
            .padding()
            
            
            
            bottomNavigation
            
        }
    }
}

private extension OnboardingWidgetsView {
    
    var header: some View {
        Text("We have widgets!")
            .font(.largeTitle.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var widgetPreview: some View {
        RoundedRectangle(cornerRadius: 28)
            .fill(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.25),
                        Color.black.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 320)
            .overlay(
                Text("Widget Preview")
                    .foregroundStyle(.white.opacity(0.6))
            )
    }
    
    var widgetTabPicker: some View {
        Picker("Widget Type", selection: $selectedTab) {
            ForEach(WidgetTab.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.thinMaterial)
        )
    }
    
    var stepsList: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepRow(index: 1, text: "Tap & Hold anywhere on your Home Screen")
            StepRow(index: 2, text: "Tap \"+\" button on the top left")
            StepRow(index: 3, text: "Scroll down & tap Luna. Then add a Widget.")
            StepRow(index: 4, text: "Bonus: Tap the top area to manage privacy")
        }
    }
    
    var bottomNavigation: some View {
        // CTA
        OnboardingNavigationButton(title: "Continue") {
            OnboardingRemindersView()
        }
    }
    
}




#Preview {
    OnboardingWidgetsView()
}
