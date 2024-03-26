//
//  ExpenseListView.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/10/24.
//

import SwiftUI

struct ExpenseListView: View {
    @StateObject var expensesData: ExpensesData
    let accountCreationDate: Date
    let today = Date()
    @State private var showingAddExpenseModal = false
    @State private var isLoading = true

    var body: some View {

        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("SimpleGreen")))
                } else {
                    List(datesInRange(start: today, end: accountCreationDate), id: \.self) { date in
                        Section(header: Text("\(date, formatter: DateFormatter.mmddyy)")) {
                            if let total = expensesData.totalExpensesByDay[date] {
                                Text("Total: $\(String(format: "%.2f", total))")
                            } else {
                                Text("No data for this date")
                            }
                        }
                    }
                }
            }
            .task {
                for date in datesInRange(start: today, end: accountCreationDate) {
                    let totalExpenses = await expensesData.fetchTotalExpenseAmount(for: date)
                    expensesData.totalExpensesByDay[date] = totalExpenses
                }
                isLoading = false
            }
            .sheet(isPresented: $showingAddExpenseModal) {
                AddExpenseView { amount, date, description in
                    Task {
                        await expensesData.addExpense(amount: amount, date: date, description: description)
                        showingAddExpenseModal = false
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button(action: { showingAddExpenseModal = true }) {
            Image(systemName: "plus")
                .foregroundColor(Color("SimpleGreen"))
        })
        .navigationBarBackButtonHidden(true)
    }
    
    private func datesInRange(start: Date, end: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = start
        while currentDate >= end {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        }
        return dates
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        let expensesData = ExpensesData()
        ExpenseListView(expensesData: expensesData, accountCreationDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
    }
}
