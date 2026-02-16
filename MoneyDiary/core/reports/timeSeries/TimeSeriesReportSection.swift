import SwiftUI
import Charts

struct TimeSeriesReportSection: View {
    
    @EnvironmentObject private var tvm: TimeSeriesViewModel
    @EnvironmentObject private var currencyManager:CurrencyManager
    @State private var selectedPeriod: TimePeriod = .daily
    @State private var animateChart: CGFloat = 0
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack{
                // Chart Title
                Text(chartTitle)
                    .font(.headline)
                
                Spacer()
                
                // Period Picker
                Picker("Period", selection: $tvm.selectedPeriod) {
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
        .onAppear {
            tvm.recomputeAll()
        }
        .onChange(of: selectedPeriod) { _, _ in
            animateChart = 0
            withAnimation(.easeOut(duration: 1.2)) {
                animateChart = 1
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                animateChart = 1
            }
        }
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
        case .daily: return "Daily Spending (Last 7 Days)"
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
        Chart(currentData) { point in
            LineMark(
                x: .value("Date", point.date),
                y: .value("Amount", point.amount * animateChart)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(.categoryPink2)
            .lineStyle(StrokeStyle(lineWidth: 2))
            
            AreaMark(
                x: .value("Date", point.date),
                y: .value("Amount", point.amount * animateChart)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(.blue.opacity(0.1))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 1)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: .dateTime.day().month(.abbreviated))
                            .font(.caption2)
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
                            .font(.caption2)
                    }
                    AxisGridLine()
                }
            }
        }
        .chartYScale(domain: 0...(maxValue(from: currentData) * 1.2))
        .frame(height: 280)
    }
    
    // MARK: - Weekly Chart
    
    private var weeklyChart: some View {
        Chart(tvm.weekly) { point in
            BarMark(
                x: .value("Week", point.date, unit: .weekOfYear),
                y: .value("Amount", point.amount * animateChart)
            )
            .foregroundStyle(.categoryPink2.gradient)
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
                y: .value("Amount", point.amount * animateChart)
            )
            .foregroundStyle(.categoryPink2.gradient)
            .cornerRadius(6)
            .annotation(position: .top) {
                if point.amount > 0 {
                    Text(formatCurrency(point.amount))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .opacity(animateChart)
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
        formatter.currencyCode = currencyManager.selectedCurrency.code
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }

    
    private func weekLabel(for date: Date) -> String {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        return "W\(weekOfYear)"
    }
}

//#Preview {
//    TimeSeriesReportSection()
//        .environmentObject({
//            let store = TransactionStore(context: <#ModelContext#>)
//            return TimeSeriesViewModel(transactionStore: store)
//        }())
//}
