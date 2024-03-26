//
//  ExpensesData.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/25/24.
//

import Foundation

class ExpensesData: ObservableObject {
    @Published var totalExpensesByDay: [Date: Double] = [:]
    
    func addExpense(amount: Double, date: Date, description: String) async {
        let dateString = DateFormatter.yearMonthDay.string(from: date)
        let newExpense = Expense(id: nil, amount: amount, date: dateString, description: description)
        do {
            try await supabase.database
                .from("expenses")
                .insert(newExpense)
                .execute()
            
            let totalExpenses = await fetchTotalExpenseAmount(for: date)
            DispatchQueue.main.async {
                self.totalExpensesByDay[date] = totalExpenses
            }
        }
        catch {
            print("Error adding expense: \(error)")
        }
    }
    
    func fetchTotalExpenseAmount(for date: Date) async -> Double {
        do {
            let dateString = DateFormatter.yearMonthDay.string(from: date)
            print("DATE: \(dateString)")
            let expenses: [Expense] = try await supabase.database
                .from("expenses")
                .select("*")
                .eq("date", value: dateString)
                .execute()
                .value
            
            return sum(expenses: expenses)
        } catch {
            print("Error fetching expenses: \(error)")
            return .zero
        }
    }
    
    private func sum(expenses: [Expense]) -> Double {
        var total: Double = 0
        for expense in expenses {
            total += expense.amount
        }
        return total
    }
}
