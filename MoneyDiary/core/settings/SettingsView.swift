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
            }
        }
        .navigationDestination(
            isPresented: $navigateToCategoryList,
            destination: {
                CategoryListView()
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
