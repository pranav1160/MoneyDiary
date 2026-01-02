//
//  Goal.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation

struct Goal: Identifiable {
    let id: UUID
    let title: String
    let targetAmount: Double
    let savedAmount: Double
    let deadline: Date
}
