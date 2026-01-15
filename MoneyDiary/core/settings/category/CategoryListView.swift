//
//  CategoryListView.swift
//  MoneyDiary
//
//  Created by Pranav on 13/01/26.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var categoryStore: CategoryStore
   
    var body: some View {
        VStack{
            CustomNavigationHeader(
                title: "Categories",
                showsBackButton: true) {
                    NavigationLink {
                        CategoryFormView(mode: .create)
                    } label: {
                        Image(systemName: "plus.capsule.fill")
                            .font(.title)
                    }
                }
            
            Spacer()
            
            categoryListSection
            
        }
        .hideSystemNavigation()
    }
    
    private var categoryListSection:some View{
        VStack(alignment: .leading, spacing: 12) {
            
            if categoryStore.categories.isEmpty {
                Text("No categories yet")
                    .foregroundStyle(.appSecondary)
                    .padding(.horizontal)
            } else {
                List{
                    ForEach(categoryStore.categories) { category in
                        NavigationLink {
                            CategoryFormView(mode: .edit(category))
                        } label: {
                            CategoryRow(category: category)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        CategoryListView()
            .withPreviewEnvironment()
    }
}
