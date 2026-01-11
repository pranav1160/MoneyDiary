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
                    .font(.body)
                    .fontWeight(.medium)

                Text(category.period.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(category.categoryColor.color.opacity(0.15))
        )
    }
}


#Preview {
    CategoryRow(category: Category.internet)
}
