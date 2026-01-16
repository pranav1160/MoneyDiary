//
//  RecurrencePickerView.swift
//  MoneyDiary
//
//  Created by Pranav on 16/01/26.
//

import SwiftUI


struct RecurrencePickerView: View {
    
    @Binding var selectedPattern: RecurrencePattern?
    @Environment(\.dismiss) private var dismiss
    
    @State private var customDays: Int = 2
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("Common")) {
                    patternRow(title: "Daily", pattern: .daily)
                    patternRow(title: "Weekly", pattern: .weekly)
                    patternRow(title: "Monthly", pattern: .monthly)
                }
                
                Section(header: Text("Custom")) {
                    HStack {
                        Text("Every")
                        
                        Stepper(
                            value: $customDays,
                            in: 1...365
                        ) {
                            Text("\(customDays)")
                                .frame(width: 40)
                        }
                        
                        Text("days")
                    }
                    
                    Button("Set Custom Interval") {
                        selectedPattern = .customDays(intervalDays: customDays)
                        dismiss()
                    }
                }
                
                if selectedPattern != nil {
                    Section {
                        Button(role: .destructive) {
                            selectedPattern = nil
                            dismiss()
                        } label: {
                            HStack{
                                Text("Remove Recurrence")
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Recurrence")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Helper
    
    @ViewBuilder
    private func patternRow(title: String, pattern: RecurrencePattern) -> some View {
        Button {
            selectedPattern = pattern
            dismiss()
        } label: {
            HStack {
                Text(title)
                Spacer()
                if selectedPattern == pattern {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}


#Preview {
    RecurrencePickerView(
        selectedPattern: .constant(.daily)
    )
}
