//
//  SettingsView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appstate
    @State private var navigateToCategoryList = false
    @State private var navigateToRecurringTransaction = false
    @State private var navigateToCurrencyChange = false
    @State private var navigateToExport = false

    var body: some View {
       
        VStack{
            CustomNavigationHeader(
                title: "Settings",
                showsBackButton: true
            )
            
            List{
                SettingsLabel(
                    text: "Sign Out",
                    sfIcon: "arrow.backward",
                    color: Color.categoryPink,
                    indicatorText: nil,
                    onTapFunc: signOut
                )
                
                SettingsLabel(
                    text: "Categories",
                    sfIcon: "square.grid.2x2.fill",
                    color: Color.categoryPurple2,
                    indicatorText: nil,
                    onTapFunc: {navigateToCategoryList = true}
                )
                
                SettingsLabel(
                    text: "Recurring Transactions",
                    sfIcon: "arrow.trianglehead.clockwise",
                    color: Color.categoryBrown,
                    indicatorText: nil,
                    onTapFunc: {navigateToRecurringTransaction = true}
                )
                
                SettingsLabel(
                    text: "Change Currency",
                    sfIcon: "dollarsign.circle.fill",
                    color: Color.categoryYellow,
                    indicatorText: nil,
                    onTapFunc: {navigateToCurrencyChange = true}
                )
                
                SettingsLabel(
                    text: "Export Data",
                    sfIcon: "square.and.arrow.up",
                    color: .blue,
                    indicatorText: nil,
                    onTapFunc: { navigateToExport = true }
                )

            }
        }
        .navigationDestination(
            isPresented: $navigateToCategoryList,
            destination: {
                CategoryListView()
            }
        )
        .navigationDestination(
            isPresented: $navigateToRecurringTransaction,
            destination: {
                RecurringTransactionsView()
            }
        )
        .navigationDestination(
            isPresented: $navigateToCurrencyChange,
            destination: {
                CurrencyInfoView()
            }
        )
        .navigationDestination(
            isPresented: $navigateToExport,
            destination: {
                ExportOptionsView()
            }
        )
        .hideSystemNavigation()
    }
    
    private func signOut() {
        withAnimation {
            dismiss()
            appstate.updateViewState(showTabBarView: false)
        }
    }
}

#Preview {
    NavigationStack{
        SettingsView()
        
    }
    .environment(AppState(showTabBar: true))
}
