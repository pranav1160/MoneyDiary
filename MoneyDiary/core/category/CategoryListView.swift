//
//  CategoryListView.swift
//  MoneyDiary
//
//  Created by Pranav on 13/01/26.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    @EnvironmentObject private var categoryStore: CategoryStore
    @EnvironmentObject private var toastManager: ToastManager
    @Query(sort: \Category.title) var categories: [Category]

    
    var body: some View {
        VStack{
            header
            
            Spacer()
            
            categoryListSection
        }
        .hideSystemNavigation()
    }
    
    private var header: some View{
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
    }
    
    private var categoryListSection:some View{
        VStack(alignment: .leading, spacing: 12) {
            
            if categories.isEmpty {
                Text("No categories yet")
                    .foregroundStyle(.appSecondary)
                    .padding(.horizontal)
            } else {
                List{
                    ForEach(categories) { category in
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
                        offsets.map { categories[$0] }
                            .forEach { categoryStore.deleteCategory($0) }
                    }
                }
            }
        }
    }
}




#Preview {
    let preview = Preview(Category.self, Budget.self)
    preview.addSamples(
        categories: Category.mockCategories,
        budgets: Budget.mockBudgets
    )
    
    return NavigationStack{
        CategoryListView()
    }
    .withPreviewEnvironment(container: preview.container)
}


