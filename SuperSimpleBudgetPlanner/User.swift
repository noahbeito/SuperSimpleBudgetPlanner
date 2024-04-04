//
//  User.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/16/24.
//

import Foundation

struct User: Codable {
    let id: UUID
    let email: String?
    let created_at: Date
    var annual_income: Int
}
