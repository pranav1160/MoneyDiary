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
    let preview = Preview(Category.self, Budget.self)
    preview.addSamples(
        categories: Category.mockCategories,
        budgets: Budget.mockBudgets
    )
    
    return  ReportView()
        .withPreviewEnvironment(container: preview.container)
    
}
