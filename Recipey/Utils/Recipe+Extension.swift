//
//  Recipe+Extension.swift
//  Recipey
//
//  Created by Julia Guzzo on 1/11/26.
//

import Foundation

extension Recipe {
    
    convenience init(from dto: RecipeDTO, imageData: Data?) {
        let title = dto.title
        let servings = dto.servings
        let readyInMinutes = dto.readyInMinutes
        let analyzedInstructions = dto.analyzedInstructions.map { AnalyzedInstructions(from: $0) }
        let extendedIngredients = dto.extendedIngredients.map { Ingredient(from: $0) }
        let sourceUrl = dto.sourceUrl
        
        self.init(
            title: title,
            image: imageData,
            servings: servings,
            readyInMinutes: readyInMinutes,
            analyzedInstructions: analyzedInstructions,
            extendedIngredients: extendedIngredients,
            sourceUrl: sourceUrl
        )
    }
}

extension Ingredient {
    convenience init(from dto: IngredientDTO) {
        self.init(
            id: dto.id,
            measures: MeasureOption(from: dto.measures),
            unit: dto.unit,
            original: dto.original
        )
    }
}

extension MeasureOption {
    convenience init(from dto: MeasureOptionDTO) {
        self.init(
            metric: Measure(from: dto.metric),
            us: Measure(from: dto.us)
        )
    }
}

extension Measure {
    convenience init(from dto: MeasureDTO) {
        self.init(
            amount: dto.amount,
            unitLong: dto.unitLong,
            unitShort: dto.unitShort
        )
    }
}

extension AnalyzedInstructions {
    convenience init(from dto: AnalyzedInstructionsDTO) {
        self.init(name: dto.name, steps: dto.steps.map { Step(from: $0) })
    }
}

extension Step {
    convenience init(from dto: StepDTO) {
        self.init(number: dto.number, step: dto.step)
    }
}
