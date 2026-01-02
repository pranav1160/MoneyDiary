//
//  SportDataItem.swift
//  MoneyDiary
//
//  Created by Pranav on 02/01/26.
//
import Foundation
import SwiftUI

struct DataItem: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let imageName:String
    let action: () -> Void
}
