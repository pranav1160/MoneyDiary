//
//  CategoryChartPoint.swift
//  MoneyDiary
//
//  Created by Pranav on 25/01/26.
//
import Foundation

struct CategoryChartPoint: Identifiable {
    let id = UUID()
    let bucketIndex: Int
    let categoryId: UUID
    let total: Double
}
