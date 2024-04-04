//
//  ExpenseListView.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/10/24.
//

import SwiftUI

struct ExpenseListView: View {
    @EnvironmentObject var expensesData: ExpensesData
    @EnvironmentObject var userSession: UserSession
    let accountCreationDate: Date
    let today = Date()
    @State private var showingAddExpenseModal = false
    @State private var showingSettingsView = false

    var body: some View {
        NavigationStack {
            VStack {
                if expensesData.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("SimpleGreen")))
                } else {
                    List(datesInRange(start: today, end: accountCreationDate), id: \.self) { date in
                        Section(header: 
                                    HStack {
                            Text("\(date, formatter: DateFormatter.mmddyy)")
                            Spacer()
                            Text("+/-")
                        }
                                    ) {
                            let dateWithoutTime = stripTime(from: date)
                            HStack {
                                if let total = expensesData.totalExpensesByDay[dateWithoutTime] {
                                    Text("$ \(String(format: "%.2f", total)) / \(dailyBudget)")
                                    Spacer()
                                    Text("\(String(format: "%.2f",Double(dailyBudget) - total))")
                                } else {
                                    Text("No data for this date")
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddExpenseModal) {
                AddExpenseView { amount, date, description in
                    Task {
                        await expensesData.addExpense(amount: amount, date: date, description: description)
                        _ = datesInRange(start: Date(), end: accountCreationDate )
                        let dateWithoutTime = stripTime(from: date)
                        let totalExpenses = await expensesData.fetchTotalExpenseAmount(for: dateWithoutTime)
                        expensesData.totalExpensesByDay[dateWithoutTime] = totalExpenses
                        showingAddExpenseModal = false
                    }
                }
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView(annualIncome: userSession.user.annual_income, showSettingsView: $showingSettingsView)
            }
        }
            .navigationBarItems(
                leading: Button(action: { showingSettingsView = true}) {
                    Image(systemName: "gear")
                        .foregroundColor(Color("SimpleGreen"))
                },
                trailing: Button(action: { showingAddExpenseModal = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color("SimpleGreen"))
            })
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Daily Expenses")
        }
    
    var dailyBudget: Int {
        userSession.user.annual_income / 365
    }
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

func stripTime(from date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components)!
}

