//
//  CustomNavigationHeader.swift
//  MoneyDiary
//
//  Created by Pranav on 15/01/26.
//
import SwiftUI

struct CustomNavigationHeader<RightContent: View>: View {
    
    let title: String
    let showsBackButton: Bool
    let rightContent: RightContent
    
    @Environment(\.dismiss) private var dismiss
    
    // ✅ INIT WITH RIGHT CONTENT
    init(
        title: String,
        showsBackButton: Bool = true,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self.title = title
        self.showsBackButton = showsBackButton
        self.rightContent = rightContent()
    }
    
    // ✅ INIT WITHOUT RIGHT CONTENT
    init(
        title: String,
        showsBackButton: Bool = true
    ) where RightContent == EmptyView {
        self.title = title
        self.showsBackButton = showsBackButton
        self.rightContent = EmptyView()
    }
    
    var body: some View {
        HStack {
            // LEFT
            if showsBackButton {
                ToolBarCircleButton(
                    systemImage: "chevron.left"
                ) {
                    dismiss()
                }
            } else {
                Spacer().frame(width: 45)
            }
            
            Spacer()
            
            // CENTER
            Text(title)
                .font(.headline)
                .lineLimit(1)
            
            Spacer()
            
            // RIGHT
            rightContent
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}


#Preview {
    VStack(spacing: 0) {
        CustomNavigationHeader(title: "New Budget") {
            ToolBarCapsuleButton(title: "Save") {
                
            }
        }
        
        Divider()
        
        
    }

}
