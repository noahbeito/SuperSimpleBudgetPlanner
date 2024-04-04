//
//  AddExpenseView.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/15/24.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var amount = ""
    @State private var date = Date()
    @State private var description = ""

    var onSubmit: (Double, Date, String) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Description", text: $description)
            }
            .navigationBarItems(
                leading: Button("Cancel", action: dismiss.callAsFunction)
                    .foregroundColor(Color("SimpleGreen")),
                trailing: Button("Add", action: submit)
                    .foregroundColor(Color("SimpleGreen")))
        }
    }

    private func submit() {
        if let amount = Double(amount) {
            onSubmit(amount, date, description)
        }
    }
}

