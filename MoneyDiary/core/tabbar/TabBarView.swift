//
//  TabBarView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject private var toastManager: ToastManager
    var body: some View {
        TabView {
            NavigationStack{
                HomeView()
            }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            NavigationStack{
                BudgetView()
            }
                .tabItem {
                    Label("Budget", systemImage: "tachometer")
                }
            
            NavigationStack{
                ReportView()
            }
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .showToast($toastManager.toast)
    }
}

#Preview {
    TabBarView()
}

