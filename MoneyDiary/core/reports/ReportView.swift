//
//  ReportView.swift
//  MoneyDiary
//
//  Created by Pranav on 24/01/26.
//

import SwiftUI

struct ReportView: View {
    
    var body: some View {
        ScrollView {
            TimeSeriesReportSection()
                
            
            Divider()
            
            CategoryReportSection()
        }
    }
}

#Preview {
    ReportView()
        .withPreviewEnvironment()
}
