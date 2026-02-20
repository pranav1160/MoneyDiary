//
//  Toast.swift
//  MoneyDiary
//
//  Created by Pranav on 19/01/26.
//


import SwiftUI

struct Toast: Identifiable, Equatable {
    
    enum Style {
        case success
        case error
        case info
    }
    
    let id = UUID()
    let style: Style
    let message: String
    let duration: Double
    let actionTitle: String?
    let action: (() -> Void)?
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.id == rhs.id &&
        lhs.style == rhs.style &&
        lhs.message == rhs.message &&
        lhs.duration == rhs.duration &&
        lhs.actionTitle == rhs.actionTitle
        // 👆 intentionally ignore `action`
    }
}

extension Toast {
    static func success(_ message: String, duration: Double = 1.5) -> Toast {
        Toast(
            style: .success,
            message: message,
            duration: duration,
            actionTitle: nil,
            action: nil
        )
    }
    
    static func error(_ message: String, duration: Double = 1.5) -> Toast {
        Toast(
            style: .error,
            message: message,
            duration: duration,
            actionTitle: nil,
            action: nil
        )
    }
    
    static func info(_ message: String, duration: Double = 1.5) -> Toast {
        Toast(
            style: .info,
            message: message,
            duration: duration,
            actionTitle: nil,
            action: nil
        )
    }
}

extension Toast {
    static func undo(
        _ message: String,
        duration: Double = 4,
        action: @escaping () -> Void
    ) -> Toast {
        Toast(
            style: .info,
            message: message,
            duration: duration,
            actionTitle: "Undo",
            action: action
        )
    }
}

extension Toast {
    static let mockSuccess = Toast.success("Demo Done successfully")
    static let mockError = Toast.error("Demo Failed this....")
    static let mockInfo = Toast.info("Demo Syncing data...")
}
