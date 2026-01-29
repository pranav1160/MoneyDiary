//
//  ReportView.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//

import SwiftUI


struct HomeView: View {
    @State private var path = NavigationPath()
    @EnvironmentObject private var transactionStore: TransactionStore
    @State private var showSettings = false
    @EnvironmentObject private var toastManager: ToastManager
    @State private var sortOption: TransactionSortOption = .day
    @EnvironmentObject private var categoryStore: CategoryStore

    
    var body: some View {
        NavigationStack(path: $path) {
            VStack{
                header
                recentTrancactionSection
            }
            .overlay(alignment: .bottomTrailing) {
                transactionAddButton
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: TransactionRoute.self) { route in
                transactionDestination(for : route)
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
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
    }
    
    private var header: some View{
        
        HStack {
            // LEFT
            LogoView(size: 40)
            
            
            Spacer()
            
            Menu {
                Picker("Sort Transactions", selection: $sortOption) {
                    ForEach(TransactionSortOption.allCases) { option in
                        Text(option.rawValue)
                            .tag(option)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(sortOption.rawValue)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .fixedSize()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(minWidth: 100)
                .animation(.none, value: sortOption)
            }
            
            
            Spacer()
            
            ToolBarCircleButton(systemImage: "gearshape") {
                showSettings = true
            }
            
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
        
    }
    
    private var sortedSections: [AnyTransactionSection] {
        switch sortOption {
            
        case .day:
            return transactionStore
                .transactionsGroupedByDay()
                .map { .day($0.date, $0.transactions) }
            
        case .week:
            return transactionStore
                .transactionsGroupedByWeek()
                .map { .week($0.weekStart, $0.transactions) }
            
        case .month:
            return transactionStore
                .transactionsGroupedByMonth()
                .map { .month($0.monthStart, $0.transactions) }
            
        case .category:
            return transactionStore
                .transactionsGroupedByCategory()
                .map { .category($0.categoryId, $0.transactions) }
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
            if let transaction = transactionStore.transactions.first(where: {
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
            if let transaction = transactionStore.transactions.first(where: {
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
    let container = {
        let preview = Preview(Category.self)
        preview.addSamples(Category.mockCategories)
        return preview.container
    }()
    HomeView()
        .withPreviewEnvironment(container: container)
}
