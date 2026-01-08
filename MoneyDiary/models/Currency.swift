//
//  UICurrency.swift
//  MoneyDiary
//
//  Created by Pranav on 05/01/26.
//
import Foundation

struct Currency: Identifiable, Hashable , Equatable, Codable {
    var id: String { code }
    let code: String
    let name: String
    let symbol: String
    let flag: String
}


extension Currency {
    static let mockCurrencies: [Currency] = [
        // 🇮🇳 Asia
        .init(code: "INR", name: "Indian Rupee", symbol: "₹", flag: "🇮🇳"),
        .init(code: "JPY", name: "Japanese Yen", symbol: "¥", flag: "🇯🇵"),
        .init(code: "CNY", name: "Chinese Yuan", symbol: "¥", flag: "🇨🇳"),
        .init(code: "KRW", name: "South Korean Won", symbol: "₩", flag: "🇰🇷"),
        .init(code: "SGD", name: "Singapore Dollar", symbol: "$", flag: "🇸🇬"),
        .init(code: "HKD", name: "Hong Kong Dollar", symbol: "$", flag: "🇭🇰"),
        .init(code: "THB", name: "Thai Baht", symbol: "฿", flag: "🇹🇭"),
        .init(code: "IDR", name: "Indonesian Rupiah", symbol: "Rp", flag: "🇮🇩"),
        
        // 🇺🇸 Americas
        .init(code: "USD", name: "US Dollar", symbol: "$", flag: "🇺🇸"),
        .init(code: "CAD", name: "Canadian Dollar", symbol: "$", flag: "🇨🇦"),
        .init(code: "MXN", name: "Mexican Peso", symbol: "$", flag: "🇲🇽"),
        .init(code: "BRL", name: "Brazilian Real", symbol: "R$", flag: "🇧🇷"),
        
        // 🇪🇺 Europe
        .init(code: "EUR", name: "Euro", symbol: "€", flag: "🇪🇺"),
        .init(code: "GBP", name: "British Pound", symbol: "£", flag: "🇬🇧"),
        .init(code: "CHF", name: "Swiss Franc", symbol: "CHF", flag: "🇨🇭"),
        .init(code: "SEK", name: "Swedish Krona", symbol: "kr", flag: "🇸🇪"),
        .init(code: "NOK", name: "Norwegian Krone", symbol: "kr", flag: "🇳🇴"),
        .init(code: "DKK", name: "Danish Krone", symbol: "kr", flag: "🇩🇰"),
        
        // 🌍 Middle East
        .init(code: "AED", name: "UAE Dirham", symbol: "د.إ", flag: "🇦🇪"),
        .init(code: "SAR", name: "Saudi Riyal", symbol: "﷼", flag: "🇸🇦"),
        .init(code: "QAR", name: "Qatari Riyal", symbol: "﷼", flag: "🇶🇦"),
        
        // 🌏 Oceania
        .init(code: "AUD", name: "Australian Dollar", symbol: "$", flag: "🇦🇺"),
        .init(code: "NZD", name: "New Zealand Dollar", symbol: "$", flag: "🇳🇿"),
        
        // 🌍 Africa
        .init(code: "ZAR", name: "South African Rand", symbol: "R", flag: "🇿🇦")
    ]
}
