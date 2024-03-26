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
    let expensesData = ExpensesData()
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
                        ExpenseListView(expensesData: expensesData, accountCreationDate: accountCreationDate)
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
            
            // Fetch the account creation date from the auth.users table.
            let userData = try await supabase.auth.user()
            let user = User(id: userData.id, email: userData.email ?? "No Email", createdAt: userData.createdAt)
            
            userSession.user = user
            accountCreationDate = user.createdAt
            navigateToExpenseListView = true
        } catch {
            print("Error logging in: \(error)")
            alertMessage = "Error logging in: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

#Preview {
    LoginView(showSignupView: .constant(false))
}
