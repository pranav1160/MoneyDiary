//
//  RecurringSwipeActionButton.swift
//  MoneyDiary
//
//  Created by Pranav on 26/01/26.
//

import SwiftUI

struct SwipeActionButton: View {
    let systemImage: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(backgroundColor)
                )
        }
        .buttonStyle(ToolbarButtonStyle())
    }
}

#Preview {
    SwipeActionButton(
        systemImage: "trash",
        backgroundColor: .red
    ) {
      
    }

}
