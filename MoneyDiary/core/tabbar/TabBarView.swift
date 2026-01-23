//
//  TabBarView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct TabBarView: View {
    let showToast: (Toast) -> Void
    var body: some View {
        TabView {
            NavigationStack{
                HomeView(showToast: showToast)
            }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            NavigationStack{
                BudgetView(showToast: showToast)
            }
                .tabItem {
                    Label("Budget", systemImage: "tachometer")
                }
            
            NavigationStack{
                SearchView()
            }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    TabBarView { Toast in
        
    }
}

