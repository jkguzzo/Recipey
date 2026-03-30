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
    
    func pngDataFromAsset(named name: String) -> Data? {
        guard let image = UIImage(named: name) else { return nil }
        return image.pngData()
    }
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: RecipeList.self, Recipe.self,
        configurations: config
    )

    let lists: [(String, String)] = [
        ("Holiday", "holiday"),
        ("Dessert", "dessert"),
        ("Salad", "salad"),
        ("Thanksgiving", "thanksgiving")
    ]
    
    for list in lists {
        let (title, image) = list
        container.mainContext.insert(RecipeList(title: title, image: pngDataFromAsset(named: image)))
    }
    
    let sampleRecipes: [(String, String, Int, Int)] = [
        ("Pancakes", "pancakes", 15, 2),
        ("Omelette", "omelette", 10, 1),
        ("Avocado Toast", "avocado toast", 5, 3),
        ("Grilled Cheese", "grilled cheese", 8, 3),
        ("Tomato Soup", "tomato soup", 20, 4),
    ]
    
    let sampleAnalyzedInstructions: [AnalyzedInstructions] = [
        AnalyzedInstructions(
            name: "Example Instructions",
            steps: [
                Step(number: 1, step: "In a medium bowl, whisk together the flour, sugar, baking powder, and salt."),
                Step(number: 2, step: "In another bowl, beat the egg, then whisk in the milk and melted butter until combined."),
                Step(number: 3, step: "Pour the wet ingredients into the dry ingredients and stir just until incorporated. Do not overmix."),
                Step(number: 4, step: "Heat a lightly oiled skillet over medium heat. Pour 1/4 cup batter for each pancake."),
                Step(number: 5, step: "Cook until bubbles form on the surface and edges look set, then flip and cook until golden brown."),
                Step(number: 6, step: "Serve warm with butter and maple syrup.")
            ]
        )
    ]
    
    let sampleExtendedIngredients: [Ingredient] = [
        Ingredient(
            id: 1,
            measures: MeasureOption(
                metric: Measure(amount: 150.0, unitLong: "grams", unitShort: "g"),
                us: Measure(amount: 1.25, unitLong: "cups", unitShort: "cup")
            ),
            unit: "cup",
            original: "1 1/4 cups all-purpose flour"
        ),
        Ingredient(
            id: 2,
            measures: MeasureOption(
                metric: Measure(amount: 25.0, unitLong: "grams", unitShort: "g"),
                us: Measure(amount: 2.0, unitLong: "tablespoons", unitShort: "tbsp")
            ),
            unit: "tbsp",
            original: "2 tbsp granulated sugar"
        ),
        Ingredient(
            id: 3,
            measures: MeasureOption(
                metric: Measure(amount: 10.0, unitLong: "grams", unitShort: "g"),
                us: Measure(amount: 2.0, unitLong: "teaspoons", unitShort: "tsp")
            ),
            unit: "tsp",
            original: "2 tsp baking powder"
        ),
        Ingredient(
            id: 4,
            measures: MeasureOption(
                metric: Measure(amount: 1.0, unitLong: "grams", unitShort: "g"),
                us: Measure(amount: 0.5, unitLong: "teaspoons", unitShort: "tsp")
            ),
            unit: "tsp",
            original: "1/2 tsp salt"
        ),
        Ingredient(
            id: 5,
            measures: MeasureOption(
                metric: Measure(amount: 240.0, unitLong: "milliliters", unitShort: "ml"),
                us: Measure(amount: 1.0, unitLong: "cups", unitShort: "cup")
            ),
            unit: "cup",
            original: "1 cup milk"
        ),
        Ingredient(
            id: 6,
            measures: MeasureOption(
                metric: Measure(amount: 1.0, unitLong: "large", unitShort: "large"),
                us: Measure(amount: 1.0, unitLong: "large", unitShort: "large")
            ),
            unit: "large",
            original: "1 large egg"
        ),
        Ingredient(
            id: 7,
            measures: MeasureOption(
                metric: Measure(amount: 30.0, unitLong: "grams", unitShort: "g"),
                us: Measure(amount: 2.0, unitLong: "tablespoons", unitShort: "tbsp")
            ),
            unit: "tbsp",
            original: "2 tbsp unsalted butter, melted"
        )
    ]

    for item in sampleRecipes {
        let (title, image, minutes, servings) = item
        let recipe = Recipe(title: title, image: pngDataFromAsset(named: image), servings: servings, readyInMinutes: minutes, analyzedInstructions: sampleAnalyzedInstructions, extendedIngredients: sampleExtendedIngredients, sourceUrl: "example.com")
        container.mainContext.insert(recipe)
    }
    
    return container
}
