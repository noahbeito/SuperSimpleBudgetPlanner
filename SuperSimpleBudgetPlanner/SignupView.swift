//
//  SignupView.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/10/24.
//

import SwiftUI

struct SignupView: View {
    @Binding var showSignupView: Bool
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            Image("SimpleLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.top, 80)
            TextField("Username", text: $username)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            SecureField("Password", text: $password)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            SecureField("Confirm Password", text: $confirmPassword)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            Button("Sign up") {
                Task {
                    await signup()
                }
            }
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Color("SimpleGreen"))
                .cornerRadius(10)
                .padding(.bottom, 20)
            Button(action: {
                withAnimation {
                    showSignupView.toggle()
                }
                }) {
                    Text("Already have an account? Log in here.")
                        .font(.subheadline)
                        .foregroundColor(Color("SimpleGreen"))
                }
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .alert(isPresented: .constant(!errorMessage.isEmpty)) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")) {
                errorMessage = ""
            })
        }
    }
    
    private func signup() async {
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }
        do {
            let result = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            print("Sign up result: \(result.user.id.uuidString)")
            try await supabase.database
                .from("users")
                .insert([
                    "id": result.user.id.uuidString,
                    "username": username
                ])
                .execute()
            showSignupView = false
        } catch {
            print("Error signing up: \(error)")
            errorMessage = "Error signing up: \(error)"
        }
    }
}

#Preview {
    SignupView(showSignupView: .constant(true))
}
