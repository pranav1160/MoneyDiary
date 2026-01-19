//
//  CallToActionButton.swift
//  MoneyDiary
//
//  Created by Pranav on 04/01/26.
//
import SwiftUI
struct CallToActionButton: View {
    
    let title: String
    var isLoading: Bool = false
    let action: () -> Void
    var isDisabled: Bool = false
    
    @GestureState private var isPressed = false
    
    var body: some View {
        Button {
            guard !isLoading && !isDisabled else { return }
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
            action()
        } label: {
            ZStack {
                Text(title)
                    .opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .scaleEffect(isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: isPressed)
        }
        .disabled(isDisabled || isLoading)
        .padding(.horizontal)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressed) { _, state, _ in
                    state = true
                }
        )
    }
    
    private var backgroundColor: Color {
        if isDisabled || isLoading {
            return Color.accentColor.opacity(0.6)
        } else {
            return Color.accentColor
        }
    }
}


#Preview {
    VStack{
        CallToActionButton(title: "Hello", action: {
            print("hello")
        }, isDisabled: false)
        
        CallToActionButton(title: "Ok", action: {
            print("ok")
        }, isDisabled: true)
    }
}
