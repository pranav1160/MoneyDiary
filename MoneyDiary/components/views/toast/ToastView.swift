//
//  ToastView.swift
//  MoneyDiary
//
//  Created by Pranav on 19/01/26.
//
import SwiftUI

struct ToastView: View {
    @Environment(\.colorScheme) private var colorScheme
    let toast: Toast
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.accent)
            
            Text(toast.message)
                .foregroundColor(.accent)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            
            
            
            if let actionTitle = toast.actionTitle,
               let action = toast.action {
                
                Button(actionTitle) {
                    action()
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
                .padding(.leading,4)
            }
        }
        .padding()
        .background(.darkPurple)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 8)
        .padding(.horizontal, 16)
    }
    
    private var icon: String {
        switch toast.style {
        case .success: return "checkmark.circle.fill"
        case .error:   return "xmark.octagon.fill"
        case .info:    return "info.circle.fill"
        }
    }
}


#Preview {
    VStack(spacing: 16) {
        ToastView(toast: .mockSuccess)
        ToastView(toast: .mockError)
        ToastView(toast: .mockInfo)
    }
}
