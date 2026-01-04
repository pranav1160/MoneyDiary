//
//  OnboardingRemindersView.swift
//  MoneyDiary
//
//  Created by Pranav on 05/01/26.
//

import SwiftUI

struct OnboardingRemindersView: View {
    @State private var selectedOption: ReminderOption? = ReminderOption.mockOptions.first
    var body: some View {
        VStack(spacing: 24) {
            
            header
            
            optionsList
            
            Spacer()
            
            bottomNavigation
        }
        .padding()

    }
}

private extension OnboardingRemindersView {
    
    var header: some View {
        VStack(spacing: 8) {
            Text("Need a reminder?")
                .font(.largeTitle.bold())
                
            
            Text("We can send helpful reminders throughout the day to remind you to track your spending!")
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 12)
    }
    
    var optionsList: some View {
        VStack(spacing: 16) {
            ForEach(ReminderOption.mockOptions) { option in
                ReminderOptionRow(
                    option: option,
                    isSelected: selectedOption == option
                )
                .onTapGesture {
                    selectedOption = option
                }
            }
        }
        .padding(.top, 8)
    }
    
    var bottomNavigation: some View {
        // CTA
        OnboardingNavigationButton(title: "Continue") {
            OnboardingCompleteView()
        }
    }
}


#Preview {
    OnboardingRemindersView()
}
