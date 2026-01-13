//
//  ListDetailView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/17/25.
//

import SwiftUI

struct ListDetailView: View {
    var list: RecipeList
    var body: some View {
            VStack {
                if list.recipes.count == 0 {
                    ContentUnavailableView("No Recipes Yet", systemImage: "fork.knife.circle.fill", description: Text("Add a recipe to this list to see it displayed here"))
                } else {
                    // TODO: show Recipes here
                }
            }
            .navigationTitle(list.title)
    }
}

#Preview {
    let recipeList = RecipeList(title: "Breakfast", image: nil)
    ListDetailView(list: recipeList)
}
