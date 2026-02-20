//
//  ToastModifier.swift
//  MoneyDiary
//
//  Created by Pranav on 19/01/26.
//
import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .top) {
                if let toast {
                    ToastView(toast: toast)
                        .padding(.top, 20)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            showToast(toast)
                        }
                        .id(toast.id) // Force view recreation for each new toast
                }
            }
            .animation(.spring(), value: toast)
            .onChange(of: toast) { _, newValue in
                guard let toast = newValue else { return }
                showToast(toast)
            }

    }
    
    private func showToast(_ toast: Toast) {
        workItem?.cancel()
        
        let task = DispatchWorkItem {
            withAnimation {
                self.toast = nil
            }
        }
        
        workItem = task
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + toast.duration,
            execute: task
        )
    }
    
    private func cancelDismiss() {
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func showToast(_ toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}
