//
//  ReminderOption.swift
//  MoneyDiary
//
//  Created by Pranav on 05/01/26.

import Foundation

struct ReminderOption: Identifiable, Equatable {
    let id = UUID()
    let emoji: String
    let title: String
    let subtitle: String
}

extension ReminderOption {
    static let mockOptions: [ReminderOption] = [
        .init(emoji: "🤫", title: "Don't send", subtitle: "Turn off all reminders"),
        .init(emoji: "🙂", title: "Gentle nudges", subtitle: "1–2 notifications daily"),
        .init(emoji: "😤", title: "Aggressive reminders", subtitle: "4–5 notifications daily"),
        .init(emoji: "🤬", title: "Relentless", subtitle: "You'll feel it (10+ daily)")
    ]
}
