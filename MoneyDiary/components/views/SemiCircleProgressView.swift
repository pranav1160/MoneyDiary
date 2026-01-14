//
//  SemiCircleProgressView.swift
//  MoneyDiary
//
//  Created by Pranav on 14/01/26.
//

import SwiftUI

struct SemiCircleProgressView: View {
    
    // MARK: - Inputs
    let strokeColor: Color
    let inputVal: Double
    let totalVal: Double
    let currencySymbol:String
    let amountToShow: Double
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
            // Background semi-circle with subtle shadow
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    strokeColor.opacity(0.12),
                    lineWidth: strokeWidth
                )
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            
            // Animated progress semi-circle
            Circle()
                .trim(from: 0, to: animatedProgress * 0.5)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            strokeColor.opacity(hasAppeared ? 0.7 : 0),
                            strokeColor.opacity(hasAppeared ? 0.85 : 0),
                            strokeColor.opacity(hasAppeared ? 1.0 : 0)
                        ]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(180)
                    ),
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round
                    )
                )
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
                .trim(from: 0, to: 0.5)
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
                HStack{
                    Text(currencySymbol)
                        .font(.title2)
                        .foregroundStyle(.appSecondary)
                    
                    Text("\(Int(amountToShow))")
                }
                    .font(.system(size: size * 0.18, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [strokeColor, strokeColor.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                Text("left this month")
                    .foregroundStyle(.appSecondary)
                    .font(.title3)
              
            }
            .rotationEffect(.degrees(-180))
            .offset(y: size * 0.1)
        }
        .frame(width: size, height: size/2)
        .rotationEffect(.degrees(180))
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
        LinearGradient(
            colors: [Color(.systemBackground), Color(.systemGray6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 50) {
            SemiCircleProgressView(
                strokeColor: .green,
                inputVal: 30,
                totalVal: 100,
                currencySymbol: "$",
                amountToShow: 70,
                size: 180,
                strokeWidth: 10
            )
            
            SemiCircleProgressView(
                strokeColor: .blue,
                inputVal: 750,
                totalVal: 1200,
                currencySymbol: "$",
                amountToShow: 450,
                size: 260,
                strokeWidth: 30
            )
            
            SemiCircleProgressView(
                strokeColor: .purple,
                inputVal: 450,
                totalVal: 500,
                currencySymbol: "$",
                amountToShow: 50,
                size: 220,
                strokeWidth: 18
            )
        }
        .padding()
    }
}
