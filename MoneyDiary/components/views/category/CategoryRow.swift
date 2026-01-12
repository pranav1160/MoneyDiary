//
//  CategoryRow.swift
//  MoneyDiary
//
//  Created by Pranav on 11/01/26.
//
import SwiftUI



struct CategoryRow: View {
    let category: Category

    var body: some View {
        HStack(spacing: 12) {
            Text(category.emoji)
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text(category.title)
                    .font(.title3)
                    .fontWeight(.medium)
            }

            Spacer()

            RoundedRectangle(cornerRadius: 5)
                .fill(category.categoryColor.color)
                .frame(width: 25,height: 25)
        }
        
    }
}


#Preview {
    CategoryRow(category: Category.internet)
}
