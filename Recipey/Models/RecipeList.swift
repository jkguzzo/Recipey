//
//  RecipeList.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/16/25.
//

import Foundation
import SwiftData

@Model
class RecipeList: Identifiable {
    var id: UUID = UUID()
    @Attribute(.unique) var title: String
    @Relationship(deleteRule: .nullify) var recipes: [Recipe] = []
    @Attribute(.externalStorage) var image: Data?
    
    init(title: String, image: Data?) {
        self.title = title
        self.image = image
    }
}
