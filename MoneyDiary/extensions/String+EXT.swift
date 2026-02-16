//
//  String+EXT.swift
//  MoneyDiary
//
//  Created by Pranav on 16/02/26.
//

import Foundation

extension String {
    var csvSafe: String {
        if contains(",") || contains("\"") || contains("\n") {
            return "\"\(replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return self
    }
}
