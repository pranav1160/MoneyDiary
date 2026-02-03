//
//  RecurrencePickerView.swift
//  MoneyDiary
//
//  Created by Pranav on 16/01/26.
//

import SwiftUI

struct RecurrencePickerView: View {
    
    @Binding var recurrencePattern: RecurrencePattern?
    @Environment(\.dismiss) private var dismiss
    @Binding var customDaysInterval: Int
    
    
    var body: some View {
        NavigationStack {
            Form {
                
                // MARK: - Common
                Section(header: Text("Common")) {
                    patternRow(title: "Daily", pattern: .daily)
                    patternRow(title: "Weekly", pattern: .weekly)
                    patternRow(title: "Monthly", pattern: .monthly)
                }
                
                // MARK: - Custom
                Section(header: Text("Custom")) {
                    HStack {
                        Text("Every")
                        
                        Stepper(value: $customDaysInterval, in: 2...365) {
                            Text("\(customDaysInterval)")
                                .frame(width: 40)
                        }
                        
                        Text("days")
                    }
                    
                    Button("Set Custom Interval") {
                        recurrencePattern = .customDays
                        dismiss()
                    }
                }
                
                // MARK: - Remove
                if recurrencePattern != nil {
                    Section {
                        Button(role: .destructive) {
                            recurrencePattern = nil
                            dismiss()
                        } label: {
                            Text("Remove Recurrence")
                        }
                    }
                }
            }
            .navigationTitle("Recurrence")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    // MARK: - Row helper
    private func patternRow(
        title: String,
        pattern: RecurrencePattern
    ) -> some View {
        Button {
            recurrencePattern = pattern
            dismiss()
        } label: {
            HStack {
                Text(title)
                Spacer()
                if recurrencePattern == pattern {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}

#Preview {
    RecurrencePickerView(
        recurrencePattern: .constant(.daily),
        customDaysInterval: .constant(2)
    )
}
