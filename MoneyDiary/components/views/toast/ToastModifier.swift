//
//  ToastModifier.swift
//  MoneyDiary
//
//  Created by Pranav on 19/01/26.
//
import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?

    func body(content: Content) -> some View {
        ZStack {
            content

            if let toast {
                VStack {
                    Spacer()

                    ToastView(toast: toast)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                                withAnimation {
                                    self.toast = nil
                                }
                            }
                        }
                }
                .padding(.bottom, 40)
            }
        }
        .animation(.spring(), value: toast)
    }
}
