//
//  AnimatedCircleProgress.swift
//  MoneyDiary
//
//  Created by Pranav on 07/01/26.
//

import SwiftUI

struct AnimatedCircleProgress: View {
    
    // MARK: - Inputs
    let strokeColor: Color
    let inputVal: Double
    let totalVal: Double
    let size: CGFloat
    let strokeWidth: CGFloat
    
    // MARK: - Derived progress
    private var progress: Double {
        guard totalVal > 0 else { return 0 }
        return min(max(inputVal / totalVal, 0), 1)
    }
    
    // MARK: - Animation state
    @State private var animatedProgress: Double = 0
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        ZStack {
            
            // Background ring with subtle shadow
            Circle()
                .stroke(
                    strokeColor.opacity(0.12),
                    lineWidth: strokeWidth
                )
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // Animated progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            strokeColor.opacity(hasAppeared ? 0.7 : 0),
                            strokeColor.opacity(hasAppeared ? 0.85 : 0),
                            strokeColor.opacity(hasAppeared ? 1.0 : 0)
                        ]),
                        center: .zero,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .shadow(
                    color: strokeColor.opacity(0.3),
                    radius: strokeWidth * 0.4,
                    x: 0,
                    y: 0
                )
                .animation(
                    .easeInOut(duration: 1.2),
                    value: animatedProgress
                )
            
            // Inner shadow effect (gives depth)
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            .black.opacity(0.08),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
                .frame(width: size - strokeWidth, height: size - strokeWidth)
            
            // Center content with shadow
            VStack(spacing: 4) {
                Text("\(Int(inputVal))")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [strokeColor, strokeColor.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                Text("of \(Int(totalVal))")
                    .font(.system(size: size * 0.1, weight: .medium, design: .rounded))
                    .foregroundStyle(.appSecondary)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                hasAppeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animatedProgress = progress
            }
        }
        .onChange(of: inputVal) { oldValue, newValue in
            animatedProgress = progress
        }
    }
}

#Preview {
    ZStack {
        // Background gradient for better preview
        LinearGradient(
            colors: [Color(.systemBackground), Color(.systemGray6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 50) {
            AnimatedCircleProgress(
                strokeColor: .green,
                inputVal: 30,
                totalVal: 100,
                size: 90,
                strokeWidth: 10
            )
            
            AnimatedCircleProgress(
                strokeColor: .blue,
                inputVal: 750,
                totalVal: 1200,
                size: 180,
                strokeWidth: 30
            )
            
            AnimatedCircleProgress(
                strokeColor: .purple,
                inputVal: 450,
                totalVal: 500,
                size: 130,
                strokeWidth: 18
            )
        }
        .padding()
    }
}
