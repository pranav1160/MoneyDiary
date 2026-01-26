//
//  CategoriesReportSection.swift
//  MoneyDiary
//
//  Created by Pranav on 25/01/26.
//

import SwiftUI
import Charts

struct CategoryReportSection: View {
    
    @EnvironmentObject private var vm: CategoryReportViewModel
    @EnvironmentObject private var categoryStore: CategoryStore
    
    @State private var animateChart = false
    
    // Aggregate data across all buckets for pie chart
    private var pieChartData: [CategoryAggregate] {
        let allCategories = vm.data.flatMap { $0 }
        let grouped = Dictionary(grouping: allCategories, by: \.id)
        
        return grouped.map { categoryId, aggregates in
            CategoryAggregate(
                id: categoryId,
                total: aggregates.reduce(0) { $0 + $1.total }
            )
        }
        .sorted { $0.total > $1.total }
        .prefix(6) // Top 6 categories
        .map { $0 }
    }
    
    private var totalAmount: Double {
        pieChartData.reduce(0) { $0 + $1.total }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            
            if pieChartData.isEmpty {
                emptyState
            } else {
                pieChart
            }
        }
        .padding()
    }
}

private extension CategoryReportSection {
    
    var header: some View {
        HStack {
            Text("Top Categories")
                .font(.headline)
            
            Spacer()
            
            Picker("Period", selection: $vm.selectedPeriod.animation(.easeInOut(duration: 0.3))) {
                ForEach(CategoryReportPeriod.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    var pieChart: some View {
        VStack(spacing: 24) {
            // Pie Chart with animations
            Chart(pieChartData) { item in
                if let category = categoryStore.categories.first(where: { $0.id == item.id }) {
                    SectorMark(
                        angle: .value("Amount", animateChart ? item.total : 0),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .foregroundStyle(category.categoryColor.color)
                    .cornerRadius(4)
                    .opacity(animateChart ? 1 : 0)
                    .annotation(position: .overlay) {
                        if item.total / totalAmount > 0.04 {
                            Text(category.emoji)
                                .font(.title)
                                .offset(y: -4)
                                .scaleEffect(animateChart ? 1 : 0.5)
                                .opacity(animateChart ? 1 : 0)
                        }
                    }
                }
            }
            .frame(width: 280, height: 280)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: animateChart)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: pieChartData.count)
            .id(vm.selectedPeriod) // Force recreation on period change
            
            // Legend with staggered animations
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(pieChartData.enumerated()), id: \.element.id) { index, item in
                    if let category = categoryStore.categories.first(where: { $0.id == item.id }) {
                        legendRow(for: category, amount: item.total)
                            .opacity(animateChart ? 1 : 0)
                            .offset(x: animateChart ? 0 : -20)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.8)
                                .delay(Double(index) * 0.05),
                                value: animateChart
                            )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            animateChart = true
        }
        .onChange(of: vm.selectedPeriod) { _, _ in
            // Reset and re-animate when period changes
            withAnimation(.easeOut(duration: 0.2)) {
                animateChart = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animateChart = true
                }
            }
        }
    }
    
    func legendRow(for category: Category, amount: Double) -> some View {
        HStack(spacing: 8) {
            // Color indicator with pulse animation
            Circle()
                .fill(category.categoryColor.color)
                .frame(width: 12, height: 12)
            
            // Emoji and title
            Text("\(category.emoji) \(category.title)")
                .font(.subheadline)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                // Amount
                Text(amount.formatted(.currency(code: "INR")))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .contentTransition(.numericText())
                
                // Percentage
                if totalAmount > 0 {
                    Text("\(percentage(amount))%")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .contentTransition(.numericText())
                }
            }
        }
    }
    
    func percentage(_ amount: Double) -> String {
        guard totalAmount > 0 else { return "0.0" }
        let pct = (amount / totalAmount) * 100
        return String(format: "%.1f", pct)
    }
    
    var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.pie")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .symbolEffect(.pulse)
            
            Text("No transactions yet")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .transition(.opacity.combined(with: .scale))
    }
}

#Preview {
    CategoryReportSection()
        .withPreviewEnvironment()
}
