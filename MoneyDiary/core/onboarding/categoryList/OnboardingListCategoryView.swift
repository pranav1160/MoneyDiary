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
                            .foregroundStyle(.appSecondary)
                    }
                    
                   
                    // MARK: - Essentials
                    CategorySectionView(
                        title: "All",
                        color: .appSecondary,
                        items: Category.mockCategories
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
