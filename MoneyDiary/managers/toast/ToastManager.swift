//
//  ToastManager.swift
//  MoneyDiary
//
//  Created by Pranav on 23/01/26.
//
import Foundation
import Combine

final class ToastManager: ObservableObject {
    @Published var toast: Toast?
    
    func show(_ toast: Toast) {
        self.toast = toast
    }
    
    func clear() {
        toast = nil
    }
}
