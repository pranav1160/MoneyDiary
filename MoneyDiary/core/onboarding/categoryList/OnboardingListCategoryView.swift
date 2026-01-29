//
//  OnboardingCategoryView.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//

import SwiftUI

struct OnboardingListCategoryView: View {
    @EnvironmentObject var categoryStore: CategoryStore
    @State private var selectedIds: Set<UUID> = []
    @Binding var path: [OnboardingRoute]
    
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
                    
                    // MARK: - Category Sections
                    CategorySectionView(
                        title: "Essentials",
                        color: .green,
                        items: OnboardingCategories.essentials,
                        selectedIds: $selectedIds
                    )
                    
                    CategorySectionView(
                        title: "Lifestyle & Shopping",
                        color: .purple,
                        items: OnboardingCategories.lifestyle,
                        selectedIds: $selectedIds
                    )
                    
                   
                    
                    CategorySectionView(
                        title: "Financial & Bills",
                        color: .orange,
                        items: OnboardingCategories.financial,
                        selectedIds: $selectedIds
                    )
                  
                    
                    CategorySectionView(
                        title: "Other",
                        color: .appSecondary,
                        items: OnboardingCategories.other,
                        selectedIds: $selectedIds
                    )
                    
                    Spacer(minLength: 100) // space for button
                }
                .padding()
            }
            
            VStack {
                Spacer()
                continueButton
            }
        }
        .hideSystemNavigation()
    }
    
    private var continueButton: some View {
        Button {
            saveSelectedCategories()
            path.append(.currency)
        } label: {
            Text("Continue")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding()
    }
    
    private func saveSelectedCategories() {
        OnboardingCategories.all
            .filter { selectedIds.contains($0.id) }
            .map {
                Category(
                    title: $0.title,
                    emoji: $0.emoji,
                    categoryColor: $0.color
                )
            }
            .forEach(categoryStore.addCategory)
    }
}

#Preview {
    OnboardingListCategoryView(path: .constant([]))
}
