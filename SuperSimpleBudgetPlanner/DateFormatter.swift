//
//  DateFormatter.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/16/24.
//

import Foundation

extension DateFormatter {
    static let mmddyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yy"
        return formatter
    }()
    
    static let monthDayYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
