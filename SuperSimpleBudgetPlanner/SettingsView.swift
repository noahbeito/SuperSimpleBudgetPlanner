//
//  SettingsView.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/31/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var expensesData: ExpensesData
    @Environment(\.dismiss) var dismiss
    @State var annualIncome: Int
    @Binding var showSettingsView: Bool
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Annual Income: \(String(userSession.user.annual_income))")) {
                    TextField("Update income", value: $annualIncome, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                Button("Save") {
                    Task {
                        await updateAnnualIncome(userId: userSession.user.id, annualIncome: annualIncome)
                        showSettingsView = false
                    }
                }
                .foregroundColor(Color("SimpleGreen"))
            }
            .navigationTitle("Settings")
            .navigationBarItems(leading: Button("Cancel", action: dismiss.callAsFunction)
                .foregroundColor(Color("SimpleGreen")))
        }
    }
    
    private func updateAnnualIncome(userId: UUID, annualIncome: Int) async {
        do {
            try await supabase.database
                .from("users")
                .update(["annual_income": annualIncome])
                .eq("id", value: userId)
                .execute()
            
            userSession.user.annual_income = annualIncome
        }
        catch {
            print("Failed to update annual income: \(error)")
        }
    }
}

