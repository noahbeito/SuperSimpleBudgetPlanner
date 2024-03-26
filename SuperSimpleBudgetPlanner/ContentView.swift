//
//  ContentView.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/10/24.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var accountCreationDate: Date?

    func checkUser() async {
        do {
            let _ = try await supabase.auth.user()
            isLoggedIn = true
        } catch {
            print("Error checking user: \(error)")
            isLoggedIn = false
        }
    }
}

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var expensesData = ExpensesData()
    @State private var showSignupView = false

    var body: some View {
        if authViewModel.isLoggedIn, let accountCreationDate = authViewModel.accountCreationDate {
            ExpenseListView(expensesData: expensesData, accountCreationDate: accountCreationDate)
                .transition(.move(edge: .trailing))
        } else if showSignupView {
            SignupView(showSignupView: $showSignupView)
                .transition(.move(edge: .trailing))
        } else {
            LoginView(showSignupView: $showSignupView)
                .transition(.move(edge: .trailing))
        }
    }
}


#Preview {
    ContentView()
}
