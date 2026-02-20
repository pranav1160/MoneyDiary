//
//  AnimatedRoundedRectProgress.swift
//  MoneyDiary
//
//  Created by Pranav on 17/01/26.
//
import SwiftUI

struct AnimatedRoundedRectProgress: View {

    // MARK: - Inputs
    let strokeColor: Color
    let inputVal: Double
    let totalVal: Double
    let size: CGSize
    let strokeWidth: CGFloat
    let cornerRadius: CGFloat
    let symbol:String

    // MARK: - Progress
    private var progress: Double {
        guard totalVal > 0 else { return 0 }
        return min(max(inputVal / totalVal, 0), 1)
    }

    private var remaining: Double {
        totalVal - inputVal
    }
    
    private var isOverspent: Bool {
        inputVal > totalVal
    }
    
    private var displayAmount: Double {
        abs(remaining)
    }
    
    private var displayLabel: String {
        isOverspent ? "overspent" : "left"
    }

    // MARK: - Animation
    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {

            // Background track
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    strokeColor.opacity(0.12),
                    lineWidth: strokeWidth
                )

            // Progress stroke
            RoundedRectProgressPath(
                progress: animatedProgress,
                cornerRadius: cornerRadius
            )
            .stroke(
                AngularGradient(
                    colors: [
                        strokeColor.opacity(0.7),
                        strokeColor.opacity(0.85),
                        strokeColor
                    ],
                    center: .center
                ),
                style: StrokeStyle(
                    lineWidth: strokeWidth,
                    lineCap: .round
                )
            )
            .animation(.easeInOut(duration: 1.2), value: animatedProgress)

            // Center content
            VStack(spacing: 4) {
                HStack{
                    Text(symbol)
                        .font(.system(size: min(size.width, size.height) * 0.15))
                        .foregroundStyle(.appSecondary)
                    
                    
                    Text("\(Int(displayAmount))")
                        .font(.system(size: min(size.width, size.height) * 0.22, weight: .bold))
                        .foregroundStyle(isOverspent ? .red : strokeColor)
                }
                
                Text(displayLabel)
                    .font(.caption)
                    .foregroundStyle(isOverspent ? .red : .secondary)
            }
        }
        .frame(width: size.width, height: size.height)
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: inputVal) { _, _ in
            animatedProgress = progress
        }
    }
}


struct RoundedRectProgressPath: Shape {
    
    var progress: Double
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let fullPath = RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )
            .path(in: rect)
        
        return fullPath.trimmedPath(from: 0, to: progress)
    }
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
}


#Preview {
    AnimatedRoundedRectProgress(
        strokeColor: .blue,
        inputVal: 450,
        totalVal: 1000,
        size: CGSize(width: 160, height: 100),
        strokeWidth: 20,
        cornerRadius: 20, 
        symbol: "$"
    )
}
