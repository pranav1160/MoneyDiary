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
    let container = {
        let preview = Preview(Category.self)
        preview.addSamples(Category.mockCategories)
        return preview.container
    }()
    ReportView()
        .withPreviewEnvironment(container: container)
}
