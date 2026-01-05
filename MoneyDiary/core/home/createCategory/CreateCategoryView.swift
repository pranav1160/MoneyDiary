//
//  CreateCategoryView.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//
import SwiftUI

struct CreateCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedColor: CategoryColor = .blue
    @State private var categoryName: String = ""
    @State private var categoryType: CategoryType = .expense
    @State private var categoryAmount: Double = 0
    @State private var categoryPeriod: CategoryPeriod = .monthly
    
    private var emojiPickerSection:some View{
        // MARK: - Preview
        EmojiPickerView(selectedColor: $selectedColor)
        
    }
    
    private var categoryAttributesSection:some View{
        VStack{
            // MARK: - Category Name
            VStack(alignment: .leading, spacing: 8) {
                Text("Category Name")
                    .font(.headline)
                AppTextField(title: "e.g. Food, Rent, Salary", text: $categoryName)
            }
            
            // MARK: - Category Type
            VStack(alignment: .leading, spacing: 8) {
                Text("Category Type")
                    .font(.headline)
                
                Picker("Type", selection: $categoryType) {
                    ForEach(CategoryType.allCases,id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            // MARK: - Amount + Period
            VStack(alignment: .leading, spacing: 8) {
                Text("Budget")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    AppNumericField(
                        title: "Amount",
                        value: $categoryAmount
                    )
                    
                    Picker("Period", selection: $categoryPeriod) {
                        ForEach(CategoryPeriod.allCases,id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.menu)
                }
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
            .frame(height: 300) // 👈 FIX
        }
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
        .navigationTitle("Create Category")
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
    
    private func onSaveClicked(){
        dismiss()
    }
    
    
}


#Preview {
    NavigationStack{
        CreateCategoryView()
    }
}

