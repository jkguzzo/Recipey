//
//  Recipe.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/18/25.
//

import Foundation

struct RecipeDTO: Codable, Identifiable {
    let title: String
    let image: String
    let servings: Int
    let readyInMinutes: Int
    let instructions: String
    let extendedIngredients: [IngredientDTO]
    let sourceUrl: String
    var id: String { sourceUrl }
}

struct IngredientDTO: Codable {
    let id: Int
    let measures: MeasureOptionDTO
    let unit: String
    let original: String
}

struct MeasureOptionDTO: Codable {
    let metric: MeasureDTO
    let us: MeasureDTO
}

struct MeasureDTO: Codable {
    let amount: Double
    let unitLong: String
    let unitShort: String
}
