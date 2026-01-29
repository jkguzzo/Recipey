//
//  SearchView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/26/25.
//

import SwiftData
import SwiftUI
import UIKit

struct SearchView: View {
    @Query var lists: [RecipeList]
    @Query var recipes: [Recipe]
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 50) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Lists")
                        .font(.title).bold()
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(lists) { list in
                                NavigationLink {
                                    ListDetailView(list: list)
                                } label: {
                                    ListCardView(list: list, onRequestDelete: { _ in })
                                    
                                }
                                
                            }
                        }
                        .frame(height: 200)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recipes")
                        .font(.title).bold()
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 16) {
                            ForEach(recipes, id: \.self) { recipe in
                                NavigationLink {
                                    RecipeDetailView(recipe: recipe)
                                } label: {
                                    ListCardSearchView(recipe: recipe)
                                        .frame(maxWidth: .infinity)

                                }
                            }
                            .frame(height: 250)
                        }
                    }

                }
            }
            .padding(.horizontal)
        }
        .searchable(text: $searchText)
        .buttonStyle(.plain)
    }
}

// creates container to be used in Previews to insert mock SwiftData objects
func inMemoryContainerForPreviews() -> ModelContainer {
    
    // uses UIKit to change image from assets into object with type "Data" for initializing RecipeList objects
    func pngDataFromAsset(named name: String) -> Data? {
        guard let image = UIImage(named: name) else { return nil }
        return image.pngData()
    }
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: RecipeList.self, Recipe.self,
        configurations: config
    )

    let lists = ["Breakfast", "Lunch", "Dinner"]
    for list in lists {
        container.mainContext.insert(RecipeList(title: list, image: pngDataFromAsset(named: "pancakes")))
    }
    
    let sampleRecipes: [(String, Int, Int)] = [
        ("Pancakes", 15, 2),
        ("Omelette", 10, 1),
        ("Avocado Toast", 5, 3),
        ("Grilled Cheese", 8, 3),
        ("Tomato Soup", 20, 4),
    ]

    let uiImage = UIImage(named: "pancakes")
    let imageData = uiImage?.pngData()

    for item in sampleRecipes {
        let (title, minutes, servings) = item
        let recipe = Recipe(title: title, image: imageData, servings: servings, readyInMinutes: minutes, analyzedInstructions: [], extendedIngredients: [], sourceUrl: "example.com")
        container.mainContext.insert(recipe)
    }
    
    return container
}

#Preview {
    let container = inMemoryContainerForPreviews()
    SearchView()
        .modelContainer(container)
}
