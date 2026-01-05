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
            
            NavigationLink {
                CreateCategoryView()
            } label: {
                Text("Create Category")
                    .font(.title2)
                    .foregroundStyle(.categoryBlue)
            }

            
            //budgetsuggestionsection
            VStack(alignment: .leading){
                Text("Not sure how much to allocate??\n we can suggest some amounts based on your income")
                    .font(.title3)
                Text("Try it!!")
                    .font(.title2)
                    .foregroundStyle(.accent)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
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
        BalanceCardView(data:.mock, backgroundColor: Color.blue)
    }
   
}

#Preview {
    NavigationStack{
        HomeView()
    }
}

