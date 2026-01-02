//
//  SportDataCardView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//


import SwiftUI

struct DataCardView: View {
    
    let title: String
    let imageName:String
    let backgroundColor: Color
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
            
            VStack(alignment: .leading, spacing: 16) {
                
                // Top Row
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.black)
                        .lineLimit(.none)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: imageName)
                        .foregroundStyle(.black)
                }
                
               
                Spacer()
                
                // Bottom Row
                HStack {
                    Text("Check")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(.black)
            }
            .padding(20)
        }
        .frame(height: 160)
        .onTapGesture {
            onTap()
        }
    }
}


#Preview {
    DataCardView(
        title: "Budgets",
        imageName: "chart.bar.fill",
        backgroundColor: Color(.lightGreen),
        onTap: {
            print("tapped")
        }
    )
}
