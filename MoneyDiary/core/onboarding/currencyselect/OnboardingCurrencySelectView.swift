//
//  OnboardingCategorySetView.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//

import SwiftUI

struct OnboardingCurrencySelectView: View {
    
    var body: some View {
        VStack(alignment:.leading){
            
            //titlesection
            VStack{
                Text("Select your currency")
                    .font(.title)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding()
            }
            
            //currency section
            CurrencyPickerView()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24))

            Spacer()
            
            // CTA
            OnboardingNavigationButton(title: "Continue") {
                OnboardingCompleteView()
            }
        }
        
        
        
    }
}

#Preview {
    OnboardingCurrencySelectView()
}
