//
//  LoginView.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/10/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToExpenseListView = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var accountCreationDate: Date?
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var expensesData: ExpensesData
    @Binding var showSignupView: Bool


    var body: some View {
        NavigationStack {
            VStack {
                Image("SimpleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 80)
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                SecureField("Password", text: $password)
                    .textContentType(.oneTimeCode)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                Button(action: {
                    Task {
                    await login()
                        let dates = datesInRange(start: Date(), end: accountCreationDate ?? Date())
                        expensesData.isLoading = true
                    for date in dates {
                        let dateWithoutTime = stripTime(from: date)
                        let totalExpenses = await expensesData.fetchTotalExpenseAmount(for: date)
                        expensesData.totalExpensesByDay[dateWithoutTime] = totalExpenses
                    }
                        expensesData.isLoading = false
                    }
                }) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color("SimpleGreen"))
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
                Button(action: {
                    withAnimation {
                        showSignupView.toggle()
                    }
                    }) {
                        Text("Don't have an account? Sign up here.")
                            .font(.subheadline)
                            .foregroundColor(Color("SimpleGreen"))
                    }
                Spacer()
                }
                .padding([.leading, .trailing], 20)
                .navigationDestination(isPresented: $navigateToExpenseListView) {
                    if let accountCreationDate = accountCreationDate {
                        ExpenseListView(userSession: _userSession, accountCreationDate: accountCreationDate)
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func login() async {
        do {
            _ = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            // Fetch the user data
            let userAuthData = try await supabase.auth.user()
            let response: [User] = try await supabase.database
                .from("users")
                .select()
                .eq("id", value: userAuthData.id)
                .execute()
                .value
                
            let user = User(id: userAuthData.id, email: userAuthData.email ?? "No Email", created_at: userAuthData.createdAt, annual_income: response[0].annual_income)
            
            userSession.user = user
            accountCreationDate = userAuthData.createdAt
            navigateToExpenseListView = true
        } catch {
            print("Error logging in: \(error)")
            alertMessage = "Error logging in: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    func datesInRange(start: Date, end: Date) -> [Date] {
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
}

#Preview {
    LoginView(showSignupView: .constant(false))
}
