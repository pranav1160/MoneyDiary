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
    var body: some View {
        
        List{
            Section{
                Button{
                    signOut()
                }label: {
                    Text("SignOut")
                        .foregroundStyle(.red)
                }
            }
        }
        
        .navigationTitle("Settings")
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
