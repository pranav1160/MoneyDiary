//
//  ExportOptionsView.swift
//  MoneyDiary
//
//  Created by Pranav on 16/02/26.
//

import SwiftUI
import SwiftData

struct ExportOptionsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ExportViewModel()
    
    @Query(sort: \Transaction.date, order: .forward)
    private var transactions: [Transaction]
    
    @Query(sort: \Category.title)
    private var categories: [Category]
    
    @State private var exportURL: URL?
    @State private var showShareSheet = false
    
    var body: some View {
        VStack{
            
            CustomNavigationHeader(title: "Export Data", showsBackButton: true)
            
            Button {
                exportURL = vm.exportCSV(
                    transactions: transactions,
                    categories: categories
                )
                showShareSheet = exportURL != nil
            } label: {
                exportRow(
                    title: "Export CSV",
                    subtitle: "Excel, Google Sheets",
                    icon: "tablecells",
                    color: .blue
                )
            }
            
            Button {
                exportURL = vm.exportPDF(
                    transactions: transactions,
                    categories: categories
                )
                showShareSheet = exportURL != nil
            } label: {
                exportRow(
                    title: "Export PDF",
                    subtitle: "Readable monthly report",
                    icon: "doc.richtext",
                    color: .purple
                )
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showShareSheet) {
            if let exportURL {
                ShareLink(item: exportURL)
            }
        }
        .hideSystemNavigation()
    }
    
    private func exportRow(
        title: String,
        subtitle: String,
        icon: String,
        color: Color
    ) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
    }


}

#Preview {
    ExportOptionsView()
        .environmentObject(ExportViewModel())
}
