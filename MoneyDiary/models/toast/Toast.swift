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
}

extension Toast {
    static func success(_ message: String, duration: Double = 1.5) -> Toast {
        Toast(style: .success, message: message, duration: duration)
    }
    
    static func error(_ message: String, duration: Double = 1.5) -> Toast {
        Toast(style: .error, message: message, duration: duration)
    }
    
    static func info(_ message: String, duration: Double = 1.5) -> Toast {
        Toast(style: .info, message: message, duration: duration)
    }
}


extension Toast {
    static let mockSuccess = Toast.success("Demo Done successfully")
    static let mockError = Toast.error("Demo Failed this....")
    static let mockInfo = Toast.info("Demo Syncing data...")
}
