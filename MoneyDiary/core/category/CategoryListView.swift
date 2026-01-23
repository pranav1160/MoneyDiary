//
//  CategoryListView.swift
//  MoneyDiary
//
//  Created by Pranav on 13/01/26.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var toastManager: ToastManager
    var body: some View {
        VStack{
            CustomNavigationHeader(
                title: "Categories",
                showsBackButton: true) {
                    NavigationLink {
                        CategoryFormView(mode: .create, onFinish: {result in
                            switch result {
                            case .created:
                                toastManager.show(.success("Catgeory Added"))
                            case .updated:
                                break
                            case .deleted:
                                break
                            }
                            
                        })
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
                            CategoryFormView(mode: .edit(category),
                                             onFinish: { result in
                                switch result {
                                case .created:
                                    break
                                case .updated:
                                    toastManager.show(.success("Cateorgy Updated"))
                                case .deleted:
                                    toastManager.show(.success("Category Deleted"))
                                }
                            })
                        } label: {
                            CategoryRow(category: category)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { offsets in
                        categoryStore.deleteCategory(at: offsets)
                        toastManager.show(.success("Category Deleted"))
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
