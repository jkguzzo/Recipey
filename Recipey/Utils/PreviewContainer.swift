//
//  PreviewContainer.swift
//  Recipey
//
//  Created by Julia Guzzo on 2/2/26.
//

import Foundation
import SwiftData
import UIKit

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
