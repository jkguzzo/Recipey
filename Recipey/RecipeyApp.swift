//
//  RecipeyApp.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/16/25.
//

import SwiftData
import SwiftUI

@main
struct RecipeyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [RecipeList.self, Recipe.self])
    }
}
