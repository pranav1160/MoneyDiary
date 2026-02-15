//
//  ReportView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State private var path = NavigationPath()
    @Query(
        sort: \Transaction.date,
        order: .reverse
    )
    private var transactions: [Transaction]
    @EnvironmentObject private var transactionStore: TransactionStore
    @EnvironmentObject private var toastManager: ToastManager
    @State private var sortOption: TransactionSortOption = .day
    @EnvironmentObject private var categoryStore: CategoryStore
    
    // Add search state
    @State private var searchText = ""
   

    var body: some View {
        NavigationStack(path: $path) {
            VStack{
                header
                SearchBarView(searchText: $searchText)
                
                recentTrancactionSection
                    .overlay(alignment: .topTrailing) {
                        sortMenu
                            .padding(.top,4)
                            .padding(.trailing)
                    }
            }
            .overlay(alignment: .bottomTrailing) {
                transactionAddButton
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: TransactionRoute.self) { route in
                transactionDestination(for : route)
            }
            .background(Color(.systemBackground))
        }
    }
    
    private var sortMenu: some View {
        Menu {
            Picker("Sort Transactions", selection: $sortOption) {
                ForEach(TransactionSortOption.allCases) { option in
                    Text(option.rawValue)
                        .tag(option)
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text(sortOption.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        Color.secondary.opacity(0.35),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    private var header: some View {
        HStack(spacing: 12) {
            
            Image(.mainlogo)
                .resizable()
                .frame(width: 40, height: 40)
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("MoneyDiary")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.primary)
            
            Spacer()
            
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.accentColor)
                    )
                    .shadow(
                        color: .black.opacity(0.25),
                        radius: 3,
                        x: 0,
                        y: 2
                    )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }


    
    // Add filtered transactions computed property
    private var filteredTransactions: [Transaction] {
        guard !searchText.isEmpty else {
            return transactions
        }
        
        return transactions.filter { transaction in
            // Search by title
            if let title = transaction.title,
               title.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            
            // Search by category name
            let categoryTitle = categoryStore.title(for: transaction.categoryId)
            if categoryTitle.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            
            // Search by amount
            let amountString = String(format: "%.2f", transaction.amount)
            if amountString.contains(searchText) {
                return true
            }
            
            return false
        }
    }
    
    private var recentTrancactionSection: some View {
        List {
            ForEach(sortedSections) { section in
                Section(header: Text(sectionTitle(section))) {
                    
                    ForEach(section.transactions) { transaction in
                        Button {
                            HapticManager.instance.tap()
                            path.append(
                                TransactionRoute.editAmount(transactionId: transaction.id)
                            )
                        } label: {
                            TransactionRow(transaction: transaction)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                HapticManager.instance.impact(style: .medium)
                                toastManager.show(.success("Transaction repeated"))
                                transactionStore.repeatTransaction(from: transaction)
                            } label: {
                                Label("Repeat", systemImage: "arrow.clockwise")
                            }
                            .tint(.blue)
                        }
                    }
                    .onDelete { offsets in
                        HapticManager.instance.notification(type: .warning)
                        toastManager.show(.success("Transaction deleted"))
                        let idsToDelete = offsets.map {
                            section.transactions[$0].id
                        }
                        
                        idsToDelete.forEach { id in
                            transactionStore.delete(id: id)
                        }
                    }
                }
            }
        }
        
        .animation(.easeInOut, value: sortOption)
        .animation(.easeInOut, value: searchText)
    }
    
  
    
    private var sortedSections: [AnyTransactionSection] {
        switch sortOption {
            
        case .day:
            return groupByDay(filteredTransactions)
                .map { .day($0.key, $0.value) }
            
        case .week:
            return groupByWeek(filteredTransactions)
                .map { .week($0.key, $0.value) }
            
        case .month:
            return groupByMonth(filteredTransactions)
                .map { .month($0.key, $0.value) }
            
        case .category:
            return groupByCategory(filteredTransactions)
                .map { .category($0.key, $0.value) }
        }
    }

    private func groupByDay(
        _ transactions: [Transaction]
    ) -> [(key: Date, value: [Transaction])] {
        
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: transactions) {
            calendar.startOfDay(for: $0.date)
        }
        
        return grouped
            .map { ($0.key, $0.value) }
            .sorted { $0.key > $1.key }
    }
    
    private func groupByWeek(
        _ transactions: [Transaction]
    ) -> [(key: Date, value: [Transaction])] {
        
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: transactions) {
            calendar.dateInterval(of: .weekOfYear, for: $0.date)!.start
        }
        
        return grouped
            .map { ($0.key, $0.value) }
            .sorted { $0.key > $1.key }
    }

    
    private func groupByMonth(
        _ transactions: [Transaction]
    ) -> [(key: Date, value: [Transaction])] {
        
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: transactions) {
            calendar.dateInterval(of: .month, for: $0.date)!.start
        }
        
        return grouped
            .map { ($0.key, $0.value) }
            .sorted { $0.key > $1.key }
    }

    private func groupByCategory(
        _ transactions: [Transaction]
    ) -> [(key: UUID, value: [Transaction])] {
        
        let grouped = Dictionary(grouping: transactions) {
            $0.categoryId
        }
        
        return grouped
            .map { ($0.key, $0.value) }
            .sorted { lhs, rhs in
                lhs.value.count > rhs.value.count
            }
    }

    
    
    private func sectionTitle(_ section: AnyTransactionSection) -> String {
        let calendar = Calendar.current
        
        switch section {
            
        case .day(let date, _):
            if calendar.isDateInToday(date) { return "Today" }
            if calendar.isDateInYesterday(date) { return "Yesterday" }
            return date.formatted(.dateTime.day().month().year())
            
        case .week(let date, _):
            return "Week of " + date.formatted(.dateTime.day().month())
            
        case .month(let date, _):
            return date.formatted(.dateTime.month().year())
            
        case .category(let id, _):
            return "\(categoryStore.title(for: id))"
        }
    }


    
    
    @ViewBuilder
    private func transactionDestination(for route : TransactionRoute) -> some View{
        switch route {
            
        case .amount:
            AmountDialPadView(
                onContinue: { amount in
                    path.append(TransactionRoute.create(amount: amount))
                }
            )
            
        case .create(let amount):
            TransactionFormView(
                purpose: .create,
                onFinish: { result in
                    path.removeLast(path.count)
                    
                    switch result {
                    case .created:
                        HapticManager.instance.notification(type: .success)
                        toastManager.show(.success("Transaction added"))
                    case .updated:
                        break
                    case .deleted:
                        break
                    }
                },
                amount: amount
            )
            
            
        case .editAmount(let transactionId):
            if let transaction = transactions.first(where: {
                $0.id == transactionId
            }) {
                AmountDialPadView(
                    initialAmount: String(abs(transaction.amount)), // 👈 prefill
                    onContinue: { newAmount in
                        path.append(
                            TransactionRoute.edit(
                                transactionId: transactionId,
                                amount: newAmount
                            )
                        )
                    }
                )
            }
        case .edit(let transactionId, let amount):
            if let transaction = transactions.first(where: {
                $0.id == transactionId
            }) {
                TransactionFormView(
                    purpose: .edit(transaction),
                    onFinish: { result in
                        path.removeLast(path.count)
                        
                        switch result {
                        case .updated:
                            HapticManager.instance.notification(type: .success)
                            toastManager.show(.success("Transaction updated"))
                        case .deleted:
                            HapticManager.instance.notification(type: .success)
                            toastManager.show(.success("Transaction deleted"))
                        case .created:
                            break
                        }
                    },
                    amount: amount
                )
                
            }
        }
    }
    
   
    
    private var transactionAddButton: some View{
        Button {
            path.append(TransactionRoute.amount)
            HapticManager.instance.tap()
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundStyle(.white)
                .padding()
                .background(Circle().fill(Color.accentColor))
                .shadow(radius: 5)
        }
        .padding()
    }
    
    
   

    
    private func dateHeader(_ date: Date) -> some View {
        let calendar = Calendar.current
        
        let text: String
        if calendar.isDateInToday(date) {
            text = "Today"
        } else if calendar.isDateInYesterday(date) {
            text = "Yesterday"
        } else {
            text = date.formatted(.dateTime.day().month().year())
        }
        
        return Text(text)
            .font(.footnote)
            .foregroundStyle(.appSecondary)
    }
    
    
}


#Preview {
    HomeView()
        .withPreviewEnvironment(container: Preview.app.container)
}

