//
//  SuperSimpleBudgetPlannerApp.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/10/24.
//

import SwiftUI

@main
struct SuperSimpleBudgetPlannerApp: App {
    @StateObject private var userSession = UserSession()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSession)
        }
    }
}
