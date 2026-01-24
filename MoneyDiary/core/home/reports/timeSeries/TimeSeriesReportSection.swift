import SwiftUI
import Charts

struct TimeSeriesReportSection: View {
    
    @EnvironmentObject private var tvm: TimeSeriesViewModel
    @State private var selectedPeriod: TimePeriod = .daily
    
    enum TimePeriod: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack{
                // Chart Title
                Text(chartTitle)
                    .font(.headline)
                
                Spacer()
                
                // Period Picker
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.menu)
            }
            // Chart View
            if currentData.isEmpty {
                emptyStateView
            } else {
                chartView
            }
        }
        .padding()
    }
    
    // MARK: - Computed Properties
    
    private var currentData: [TimeSeriesPoint] {
        switch selectedPeriod {
        case .daily: return tvm.daily
        case .weekly: return tvm.weekly
        case .monthly: return tvm.monthly
        }
    }
    
    private var chartTitle: String {
        switch selectedPeriod {
        case .daily: return "Daily Spending (Last 30 Days)"
        case .weekly: return "Weekly Spending (Last 4 Weeks)"
        case .monthly: return "Monthly Spending (Last 6 Months)"
        }
    }
    
    // MARK: - Chart View
    
    @ViewBuilder
    private var chartView: some View {
        switch selectedPeriod {
        case .daily:
            dailyChart
        case .weekly:
            weeklyChart
        case .monthly:
            monthlyChart
        }
    }
    
    // MARK: - Daily Chart
    
    private var dailyChart: some View {
        Chart(tvm.daily) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value("Amount", point.amount)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(.blue)
            .lineStyle(StrokeStyle(lineWidth: 2))
            
            AreaMark(
                x: .value("Date", point.date),
                y: .value("Amount", point.amount)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(.blue.opacity(0.1))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 5)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: .dateTime.month(.abbreviated).day())
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    AxisGridLine()
                    AxisTick()
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                if let amount = value.as(Double.self) {
                    AxisValueLabel {
                        Text(formatCurrency(amount))
                    }
                    AxisGridLine()
                }
            }
        }
        .chartYScale(domain: 0...(maxValue(from: tvm.daily) * 1.1))
        .frame(height: 280)
    }
    
    // MARK: - Weekly Chart
    private var weeklyChart: some View {
        Chart(tvm.weekly) { point in
            BarMark(
                x: .value("Week", point.date, unit: .weekOfYear),
                y: .value("Amount", point.amount)
            )
            .foregroundStyle(.green.gradient)
            .cornerRadius(6)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .weekOfYear)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: .dateTime.month(.abbreviated).day())
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    AxisGridLine()
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                if let amount = value.as(Double.self) {
                    AxisValueLabel {
                        Text(formatCurrency(amount))
                    }
                    AxisGridLine()
                }
            }
        }
        .chartYScale(domain: 0...(maxValue(from: tvm.weekly) * 1.1))
        .frame(height: 280)
    }
    
    // MARK: - Monthly Chart
    
    private var monthlyChart: some View {
        Chart(tvm.monthly) { point in
            BarMark(
                x: .value("Month", point.date),
                y: .value("Amount", point.amount)
            )
            .foregroundStyle(.orange.gradient)
            .cornerRadius(6)
            .annotation(position: .top) {
                if point.amount > 0 {
                    Text(formatCurrency(point.amount))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .month)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: .dateTime.month(.abbreviated))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    AxisGridLine()
                    AxisTick()
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                if let amount = value.as(Double.self) {
                    AxisValueLabel {
                        Text(formatCurrency(amount))
                    }
                    AxisGridLine()
                }
            }
        }
        .chartYScale(domain: 0...(maxValue(from: tvm.monthly) * 1.1))
        .frame(height: 280)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No data available")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(height: 280)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helpers
    
    private func maxValue(from points: [TimeSeriesPoint]) -> Double {
        points.map(\.amount).max() ?? 100
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "₹0"
    }
    
    private func weekLabel(for date: Date) -> String {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        return "W\(weekOfYear)"
    }
}

#Preview {
    TimeSeriesReportSection()
        .environmentObject({
            let store = TransactionStore()
            return TimeSeriesViewModel(transactionStore: store)
        }())
}
