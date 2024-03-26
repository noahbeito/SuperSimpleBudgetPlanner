//
//  Supabase.swift
//  SuperSimpleBudgetPlanner
//
//  Created by Noah Beito on 3/10/24.
//

import Foundation
import Supabase

let supabase = SupabaseClient(supabaseURL: URL(string: "https://kkjaiygaeilmvvghyvvm.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtramFpeWdhZWlsbXZ2Z2h5dnZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAxMTU4MTMsImV4cCI6MjAyNTY5MTgxM30.V1R3QUDdfWSmzMiFJwVJMA0iVuZWQRnclyF5DM1oipw")

let auth = supabase.auth
