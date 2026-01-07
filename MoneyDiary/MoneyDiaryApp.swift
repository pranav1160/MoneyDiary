//
//  MoneyDiaryApp.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI
import SwiftData

@main
struct MoneyDiaryApp: App {
    
    @StateObject private var categoryStore = CategoryStore()
    @StateObject private var transactionStore = TransactionStore()
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(categoryStore)
                .environmentObject(transactionStore)
        }
    }
}
