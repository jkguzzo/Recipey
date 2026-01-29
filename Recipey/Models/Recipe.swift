//
//  Recipe.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/18/25.
//

import Foundation
import SwiftData

@Model
class Recipe {
    var title: String
    @Attribute(.externalStorage) var image: Data?
    var servings: Int
    var readyInMinutes: Int
    var analyzedInstructions: [AnalyzedInstructions]
    var extendedIngredients: [Ingredient]
    var sourceUrl: String
    var id: String { sourceUrl }
    var isFavorite: Bool = false
    var dateAdded: Date = Date.now
    
    init(title: String, image: Data?, servings: Int, readyInMinutes: Int, analyzedInstructions: [AnalyzedInstructions], extendedIngredients: [Ingredient], sourceUrl: String) {
        self.title = title
        self.image = image
        self.servings = servings
        self.readyInMinutes = readyInMinutes
        self.analyzedInstructions = analyzedInstructions
        self.extendedIngredients = extendedIngredients
        self.sourceUrl = sourceUrl
    }
}

@Model
class Ingredient {
    var id: Int
    var measures: MeasureOption
    var unit: String
    var original: String
    
    init(id: Int, measures: MeasureOption, unit: String, original: String) {
        self.id = id
        self.measures = measures
        self.unit = unit
        self.original = original
    }
}

@Model
class MeasureOption {
    var metric: Measure
    var us: Measure
    
    init(metric: Measure, us: Measure) {
        self.metric = metric
        self.us = us
    }
}

@Model
class Measure {
    var amount: Double
    var unitLong: String
    var unitShort: String
    
    init(amount: Double, unitLong: String, unitShort: String) {
        self.amount = amount
        self.unitLong = unitLong
        self.unitShort = unitShort
    }
}

@Model
class AnalyzedInstructions {
    var name: String
    var steps: [Step]
    
    init(name: String, steps: [Step]) {
        self.name = name
        self.steps = steps
    }
}

@Model
class Step {
    var number: Int
    var step: String
    
    init(number: Int, step: String) {
        self.number = number
        self.step = step
    }
}
