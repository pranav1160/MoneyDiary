//
//  HapticManager.swift
//  MoneyDiary
//
//  Created by Pranav on 19/01/26.
//

import SwiftUI

class HapticManager {
    
    static let instance = HapticManager() // Singleton
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

extension HapticManager {
    func tap() { impact(style: .light) }
    func delete() { impact(style: .medium) }
    func success() { notification(type: .success) }
    func warning() { notification(type: .warning) }
}


