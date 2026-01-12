//
//  TabBarView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            NavigationStack{
                HomeView()
            }
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
            
            NavigationStack{
                TransactionView()
            }
                .tabItem {
                    Label("Expense", systemImage: "chart.line.text.clipboard")
                }
            
            NavigationStack{
                BudgetView()
            }
                .tabItem {
                    Label("Budget", systemImage: "person.fill")
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
    TabBarView()
}

