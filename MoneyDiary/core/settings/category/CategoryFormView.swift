//
//  CreateCategoryView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//
import SwiftUI

struct CategoryFormView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var categoryStore: CategoryStore
    
    let mode: CategoryFormMode
    
    @State private var selectedEmoji: String
    @State private var selectedColor: CategoryColor
    @State private var categoryName: String
    
    // MARK: - Init for Create & Edit
    init(mode: CategoryFormMode) {
        self.mode = mode
        
        switch mode {
        case .create:
            _selectedEmoji = State(initialValue: "👽") //pick random emoji
            _selectedColor = State(initialValue: .blue)
            _categoryName = State(initialValue: "")
            
        case .edit(let category):
            _selectedEmoji = State(initialValue: category.emoji)
            _selectedColor = State(initialValue: category.categoryColor)
            _categoryName = State(initialValue: category.title)
        }
    }

    
    private var emojiPickerSection: some View {
        EmojiPickerView(
            selectedColor: $selectedColor,
            selectedEmoji: $selectedEmoji
        )
    }
    
    private var navigationTitle: String {
        switch mode {
        case .create: return "Create Category"
        case .edit: return "Edit Category"
        }
    }


    
    private var categoryAttributesSection:some View{
        VStack{
            // MARK: - Category Name
            VStack(alignment: .leading, spacing: 8) {
                Text("Category Name")
                    .font(.headline)
                AppTextField(title: "e.g. Food, Rent, Salary", text: $categoryName)
            }
        }
        
    }
    
    private var colorPickerSection:some View{
        VStack{
            Text("Color")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ColorPickerView(selectedColor: $selectedColor)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func createCategory() {
        let category = Category(
            id: UUID(),
            title: categoryName,
            emoji:  selectedEmoji,
            categoryColor: selectedColor
        )
        categoryStore.addCategory(category)
    }

    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                
                emojiPickerSection
                
                categoryAttributesSection
                
                colorPickerSection
           
            }
            .padding(.horizontal, 8)
        }
        .navigationTitle(navigationTitle)

        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)

        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button{
                    onCancelClicked()
                }label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    onSaveClicked()
                }label: {
                    Text("Save")
                }
            }
        }
    }
    
    private func onCancelClicked(){
        dismiss()
    }
    
    private func onSaveClicked() {
        switch mode {
        case .create:
            createCategory()
            
        case .edit(let category):
            updateCategory(existing: category)
        }
        dismiss()
    }
    private func updateCategory(existing category: Category) {
        let updated = Category(
            id: category.id, // 👈 KEEP SAME ID (CRITICAL)
            title: categoryName,
            emoji: selectedEmoji,
            categoryColor: selectedColor,
        )
        
        categoryStore.updateCategory(updated)
    }

    
    
}


#Preview {
    NavigationStack{
        CategoryFormView(mode: .create)
    }
}

