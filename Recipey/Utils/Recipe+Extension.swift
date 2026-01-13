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
        let instructions = dto.instructions
        let sourceUrl = dto.sourceUrl
        
        self.init(
            title: title,
            image: imageData,
            servings: servings,
            readyInMinutes: readyInMinutes,
            instructions: instructions,
            extendedIngredients: [],
            sourceUrl: sourceUrl
        )
    }
}
