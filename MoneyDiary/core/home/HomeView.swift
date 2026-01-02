//
//  HomeView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showSettings = false
    
    
    var body: some View {
        ScrollView{
            
            balanceCard
            
            HStack{
                Text("Overview")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)

            gridItems

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .navigationDestination(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    private var balanceCard:some View{
        BalanceCardView(data:.mock)
    }
    private var gridItems:some View{
        DataGridView(
            items: [
                DataItem(
                    title: "Budgets",
                    color: .lightGreen,
                    imageName: "chart.bar"
                ) {
                    print("Budgets tapped")
                },
                
                DataItem(
                    title: "Loans",
                    color: .lightPink,
                    imageName: "banknote"
                ) {
                    print("Loans tapped")
                },
                
                DataItem(
                    title: "Goals",
                    color: .lightRed,
                    imageName: "flag"
                ) {
                    print("Goals tapped")
                },
                
                DataItem(
                    title: "Labels",
                    color: .lightPurple,
                    imageName: "tag"
                ) {
                    print("Labels tapped")
                },
                
                DataItem(
                    title: "Analytics",
                    color: .lightPeach,
                    imageName: "chart.line.uptrend.xyaxis"
                ) {
                    print("Analytics tapped")
                },
                
                DataItem(
                    title: "Recurring",
                    color: .lightOrange,
                    imageName: "square.grid.2x2"
                ) {
                    print("Recurring tapped")
                },
                
                DataItem(
                    title: "Categories",
                    color: .lightYellow,
                    imageName: "square.grid.2x2"
                ) {
                    print("Categories tapped")
                },
                
                DataItem(
                    title: "Weekly Summary",
                    color: .lightBlue,
                    imageName: "square.grid.2x2"
                ) {
                    print("Weekly Summary tapped")
                },
                
                DataItem(
                    title: "Places",
                    color: .lightGreen,
                    imageName: "square.grid.2x2"
                ) {
                    print("Places tapped")
                },
                
                DataItem(
                    title: "Person",
                    color: .lightPink,
                    imageName: "square.grid.2x2"
                ) {
                    print("Person tapped")
                },
                
            ]
        )
    }
    
}

#Preview {
    NavigationStack{
        HomeView()
    }
}

