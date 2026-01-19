//
//  ToastView.swift
//  MoneyDiary
//
//  Created by Pranav on 19/01/26.
//
import SwiftUI

struct ToastView: View {
    let toast: Toast

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                

            Text(toast.message)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            
        }
        .padding()
        .background(.accent)
        .foregroundColor(.white)
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

    private var backgroundColor: Color {
        switch toast.style {
        case .success: return .green
        case .error:   return .red
        case .info:    return .blue
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
