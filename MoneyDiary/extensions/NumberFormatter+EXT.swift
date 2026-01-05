//
//  NumberFormatter+EXT.swift
//  MoneyDiary
//
//  Created by Pranav on 06/01/26.
//

import Foundation

extension NumberFormatter {
    static let decimal: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        return f
    }()
}
