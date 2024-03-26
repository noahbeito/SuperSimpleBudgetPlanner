//
//  Expense.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/16/24.
//

import Foundation

struct Expense: Identifiable, Encodable, Decodable {
    let id: Int?
    let amount: Double
    let date: String
    let description: String
    
    var dateAsDate: Date? { DateFormatter.yearMonthDay.date(from: date) }
}
