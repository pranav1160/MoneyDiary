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
        
        guard !transactions.isEmpty else {
            print("⚠️ No transactions to export")
            return nil
        }
        
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
            fileName: "MoneyDiary_Transactions_\(UUID().uuidString).csv"
        )
        
        if let fileURL {
            print("✅ CSV export successful")
            print("📄 File path:", fileURL.path)
        } else {
            print("❌ CSV export failed: File URL is nil")
        }
        
        return fileURL
    }
    
    private func drawSeparator(y: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: y))
        path.addLine(to: CGPoint(x: 575, y: y))
        UIColor.gray.setStroke()
        path.lineWidth = 0.5
        path.stroke()
    }

    
    func exportPDF(
        transactions: [Transaction],
        categories: [Category]
    ) -> URL? {
        
        print("📄 Export PDF started")
        print("➡️ Transactions count:", transactions.count)
        
        guard !transactions.isEmpty else {
            print("⚠️ No transactions to export")
            return nil
        }
        
        let categoryMap = Dictionary(
            uniqueKeysWithValues: categories.map { ($0.id, $0) }
        )
        
        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(x: 0, y: 0, width: 595, height: 842) // A4
        )
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("MoneyDiary_Report_\(UUID().uuidString).pdf")
        
        do {
            try renderer.writePDF(to: url) { ctx in
                ctx.beginPage()
                
                let titleAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 22)
                ]
                
                let headerAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 12)
                ]
                
                let bodyAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 11)
                ]
                
                let emojiAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 14)
                ]
                
                let legendAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 10),
                    .foregroundColor: UIColor.gray
                ]
                
                var y: CGFloat = 40
                let lineHeight: CGFloat = 20
                let pageBottomMargin: CGFloat = 800
                
                // Title
                "MoneyDiary Report"
                    .draw(at: CGPoint(x: 20, y: y), withAttributes: titleAttrs)
                y += 40
                
                var headerX: CGFloat = 20
                
                "Date".draw(at: CGPoint(x: headerX, y: y), withAttributes: headerAttrs)
                headerX += 110
                
                "Title".draw(at: CGPoint(x: headerX, y: y), withAttributes: headerAttrs)
                headerX += 150
                
                "Category".draw(at: CGPoint(x: headerX, y: y), withAttributes: headerAttrs)
                headerX += 120
                
                "Emoji".draw(at: CGPoint(x: headerX, y: y), withAttributes: headerAttrs)
                headerX += 45
                
                "Amount".draw(at: CGPoint(x: headerX, y: y), withAttributes: headerAttrs)
                headerX += 95
                
                "S".draw(at: CGPoint(x: headerX, y: y), withAttributes: headerAttrs)
                
           

                y += 25
                
                drawSeparator(y: y)
                y += 15
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM yyyy"
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.minimumFractionDigits = 2
                numberFormatter.maximumFractionDigits = 2
                
                for tx in transactions {
                    
                    // Page break
                    if y + lineHeight > pageBottomMargin {
                        ctx.beginPage()
                        y = 40
                        
                        "MoneyDiary Report (continued)"
                            .draw(at: CGPoint(x: 20, y: y), withAttributes: titleAttrs)
                        y += 30
                        
                        
                        
                        drawSeparator(y: y)
                        y += 15
                    }
                    
                    let date = dateFormatter.string(from: tx.date)
                    let category = categoryMap[tx.categoryId]?.title ?? "Unknown"
                    let emoji = categoryMap[tx.categoryId]?.emoji ?? "💰"
                    let title = tx.title?.isEmpty == false ? tx.title! : category
                    let formattedAmount =
                    numberFormatter.string(from: NSNumber(value: tx.amount)) ?? "\(tx.amount)"
                    
                    let source = sourceSymbol(for: tx.source)
                    
                    let truncatedTitle = title.truncated(to: 20)
                    let truncatedCategory = category.truncated(to: 15)
                    
                    var xOffset: CGFloat = 20
                    
                    // Date
                    date.draw(at: CGPoint(x: xOffset, y: y), withAttributes: bodyAttrs)
                    xOffset += 110
                    
                    // Title
                    truncatedTitle.draw(at: CGPoint(x: xOffset, y: y), withAttributes: bodyAttrs)
                    xOffset += 150
                    
                    // Category
                    truncatedCategory.draw(at: CGPoint(x: xOffset, y: y), withAttributes: bodyAttrs)
                    xOffset += 120
                    
                    // Emoji
                    emoji.draw(at: CGPoint(x: xOffset, y: y - 2), withAttributes: emojiAttrs)
                    xOffset += 45
                    
                    // Amount (right aligned)
                    let amountText = "₹\(formattedAmount)"
                    let amountSize = amountText.size(withAttributes: bodyAttrs)
                    amountText.draw(
                        at: CGPoint(x: xOffset + 90 - amountSize.width, y: y),
                        withAttributes: bodyAttrs
                    )
                    xOffset += 95
                    
                    // Source (R / M)
                    source.draw(at: CGPoint(x: xOffset, y: y), withAttributes: bodyAttrs)
                    
                    y += lineHeight
                }
                
                // Totals
                let total = transactions.reduce(0) { $0 + $1.amount }
                let formattedTotal =
                numberFormatter.string(from: NSNumber(value: total)) ?? "\(total)"
                
                let footerY: CGFloat = pageBottomMargin - 40
                let totalY = footerY - 25
                
                let totalText =
                "Total: \(transactions.count) txns  •  ₹\(formattedTotal)"
                
                totalText.draw(
                    at: CGPoint(x: 20, y: totalY),
                    withAttributes: headerAttrs
                )
                
                // Footer legend
                drawSeparator(y: footerY)
                
                let legendText = "S: R = Recurring (Auto), M = Manual"
                legendText.draw(
                    at: CGPoint(x: 20, y: footerY + 10),
                    withAttributes: legendAttrs
                )
            }
            
            print("✅ PDF export successful")
            print("📄 File path:", url.path)
            return url
            
        } catch {
            print("❌ PDF export failed:", error.localizedDescription)
            return nil
        }
    }

    private func sourceSymbol(for source: TransactionSource) -> String {
        switch source {
        case .recurringGenerated:
            return "R"
        case .manual:
            return "M"
        case .recurringTemplate:
            return "R"
        case .recurringPaused:
            return "R"
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
    
    // Cleanup method to remove old temp files
    func cleanupTempFiles() {
        let tempDir = FileManager.default.temporaryDirectory
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: tempDir,
                includingPropertiesForKeys: nil
            )
            
            for fileURL in contents {
                if fileURL.lastPathComponent.hasPrefix("MoneyDiary_") {
                    try? FileManager.default.removeItem(at: fileURL)
                }
            }
            print("🧹 Temp files cleaned up")
        } catch {
            print("⚠️ Failed to cleanup temp files:", error.localizedDescription)
        }
    }
}
