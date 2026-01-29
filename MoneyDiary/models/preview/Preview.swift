//
//  Preview.swift
//  MoneyDiary
//
//  Created by Pranav on 29/01/26.
//


import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer

    init(_ models: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("The preview container couldn't be created")
        }
    }

    func addSamples(
        categories: [Category] = [],
        budgets: [Budget] = []
    ) {
        Task { @MainActor in
            categories.forEach {
                container.mainContext.insert($0)
            }
            budgets.forEach {
                container.mainContext.insert($0)
            }
        }
    }

}
