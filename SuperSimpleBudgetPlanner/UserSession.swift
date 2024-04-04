//
//  UserSession.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/16/24.
//

import Foundation

class UserSession: ObservableObject {
    @Published var user: User = User(id: UUID(), email: "", created_at: Date(), annual_income: 0)
}
