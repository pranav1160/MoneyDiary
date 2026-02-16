//
//  ExportViewModel.swift
//  MoneyDiary
//
//  Created by Pranav on 16/02/26.
//

import Combine
import Foundation
import SwiftData
import UIKit

@MainActor
final class ExportViewModel: ObservableObject {
    
    func exportCSV(
        transactions: [Transaction],
        categories: [Category]
    ) -> URL? {
        
        print("📤 Export CSV started")
        print("➡️ Transactions count:", transactions.count)
        print("➡️ Categories count:", categories.count)
        
        let categoryMap = Dictionary(
            uniqueKeysWithValues: categories.map { ($0.id, $0) }
        )
        
        print("✅ Category map created with \(categoryMap.count) entries")
        
        var csv = "Date,Title,Category,Emoji,Amount,Source\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for (index, tx) in transactions.enumerated() {
            let date = dateFormatter.string(from: tx.date)
            
            let title = (tx.title?.isEmpty == false
                         ? tx.title!
                         : categoryMap[tx.categoryId]?.title ?? "Transaction")
            
            let category = categoryMap[tx.categoryId]?.title ?? "Unknown"
            let emoji = categoryMap[tx.categoryId]?.emoji ?? ""
            let amount = tx.amount
            let source = tx.source.rawValue
            
            if category == "Unknown" {
                print("⚠️ Transaction \(index) has unknown categoryId:", tx.categoryId)
            }
            
            csv += "\(date),\(title.csvSafe),\(category.csvSafe),\(emoji),\(amount),\(source)\n"
        }
        
        let fileURL = saveToTempFile(
            content: csv,
            fileName: "MoneyDiary_Transactions.csv"
        )
        
        if let fileURL {
            print("✅ CSV export successful")
            print("📄 File path:", fileURL.path)
        } else {
            print("❌ CSV export failed: File URL is nil")
        }
        
        return fileURL
    }
    
    func exportPDF(
        transactions: [Transaction],
        categories: [Category]
    ) -> URL? {
        
        print("📄 Export PDF started")
        print("➡️ Transactions count:", transactions.count)
        
        let categoryMap = Dictionary(
            uniqueKeysWithValues: categories.map { ($0.id, $0) }
        )
        
        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: 595, height: 842) // A4
        )
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("MoneyDiary_Report.pdf")
        
        do {
            try renderer.writePDF(to: url) { ctx in
                ctx.beginPage()
                
                let titleAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 22)
                ]
                
                let bodyAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14)
                ]
                
                var y: CGFloat = 40
                
                // Title
                "MoneyDiary Report"
                    .draw(at: CGPoint(x: 20, y: y), withAttributes: titleAttrs)
                
                y += 40
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy"
                
                for (index, tx) in transactions.enumerated() {
                    
                    // Page break
                    if y > 800 {
                        ctx.beginPage()
                        y = 40
                    }
                    
                    let date = dateFormatter.string(from: tx.date)
                    let category = categoryMap[tx.categoryId]?.title ?? "Unknown"
                    let title = tx.title?.isEmpty == false ? tx.title! : category
                    
                    let line =
                    "\(index + 1). \(date)  •  \(title)  •  ₹\(tx.amount)"
                    
                    line.draw(
                        at: CGPoint(x: 20, y: y),
                        withAttributes: bodyAttrs
                    )
                    
                    y += 22
                }
            }
            
            print("✅ PDF export successful")
            print("📄 File path:", url.path)
            return url
            
        } catch {
            print("❌ PDF export failed:", error.localizedDescription)
            return nil
        }
    }

    
    private func saveToTempFile(
        content: String,
        fileName: String
    ) -> URL? {
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(fileName)
        
        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
            print("💾 File written successfully:", fileName)
            return url
        } catch {
            print("❌ Failed to write file:", fileName)
            print("Error:", error.localizedDescription)
            return nil
        }
    }
}
