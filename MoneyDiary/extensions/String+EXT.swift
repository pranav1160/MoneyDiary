//
//  String+EXT.swift
//  MoneyDiary
//
//  Created by Pranav on 16/02/26.
//

import Foundation

extension String {
    var csvSafe: String {
        let escaped = self.replacingOccurrences(of: "\"", with: "\"\"")
        // Wrap in quotes if contains comma, newline, or quote
        if self.contains(",") || self.contains("\n") || self.contains("\"") {
            return "\"\(escaped)\""
        }
        return escaped
    }
    
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length - trailing.count)) + trailing
        }
        return self
    }
}
