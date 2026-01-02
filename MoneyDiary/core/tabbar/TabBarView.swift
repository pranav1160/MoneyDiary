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
           
            AccountView()
                .tabItem {
                    Label("Accounts", systemImage: "person.fill")
                }
            
            ReportView()
                .tabItem {
                    Label("Reports", systemImage: "chart.line.text.clipboard")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    TabBarView()
}


#Preview {
    TabBarView()
}
