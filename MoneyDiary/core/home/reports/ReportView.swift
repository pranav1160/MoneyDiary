//
//  ReportView.swift
//  MoneyDiary
//
//  Created by Pranav on 24/01/26.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject private var tvm: TimeSeriesViewModel
    
    var body: some View {
        ScrollView {
            TimeSeriesReportSection()
                .environmentObject(tvm)
                .navigationTitle("Reports")
                .navigationBarTitleDisplayMode(.inline)
            
            Divider()
            
            CategoryReportSection()
        }
    }
}

#Preview {
    ReportView()
        .withPreviewEnvironment()
}
