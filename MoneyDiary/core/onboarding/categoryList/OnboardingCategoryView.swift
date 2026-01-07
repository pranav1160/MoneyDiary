//
//  OnboardingCategoryView.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//

import SwiftUI

struct OnboardingListCategoryView: View {
    
    
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Let's create some categories")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Here are some suggestions for you (you can always add/edit these later)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                   
                    // MARK: - Essentials
                    CategorySectionView(
                        title: "Essentials",
                        color: .pink,
                        items: CategoryItem.essentials
                    )
                
                    // MARK: - Personal
                    CategorySectionView(
                        title: "Personal",
                        color: .yellow,
                        items: CategoryItem.personal
                    )
                    
                    // MARK: - Finance
                    CategorySectionView(
                        title: "Finance",
                        color: .mint,
                        items: CategoryItem.finance
                    )


                    
                    Spacer(minLength: 100) // space for button
                }
                .padding()
            }
            
            // Bottom CTA (fixed)
            VStack {
                Spacer()
                OnboardingNavigationButton(title: "Continue") {
                    OnboardingCurrencySelectView()
                }
            }
        }
    }
}


#Preview {
    OnboardingListCategoryView()
}
