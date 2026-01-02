//
//  SportDataGridView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//


import SwiftUI

struct DataGridView: View {
    
    let items: [DataItem]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items) { item in
                DataCardView(
                    title: item.title,
                    imageName: item.imageName,
                    backgroundColor: item.color
                ) {
                    item.action()
                }
            }
        }
        .padding()
    }
}

#Preview {
    DataGridView(
        items: [
            DataItem(
                title: "Budgets",
                color: .lightGreen,
                imageName: "chart.bar"
            ) {
                print("Budgets tapped")
            },
            
            DataItem(
                title: "Loans",
                color: .lightPink,
                imageName: "banknote"
            ) {
                print("Loans tapped")
            },
            
            DataItem(
                title: "Goals",
                color: .lightRed,
                imageName: "flag"
            ) {
                print("Goals tapped")
            },
            
            DataItem(
                title: "Labels",
                color: .lightPurple,
                imageName: "tag"
            ) {
                print("Labels tapped")
            },
            
            DataItem(
                title: "Analytics",
                color: .lightGreen,
                imageName: "chart.line.uptrend.xyaxis"
            ) {
                print("Analytics tapped")
            },
            
            DataItem(
                title: "Categories",
                color: .lightPink,
                imageName: "square.grid.2x2"
            ) {
                print("Categories tapped")
            }
        ]
    )
}
