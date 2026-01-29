//
//  RecipeCardView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/27/25.
//

import SwiftData
import SwiftUI

struct RecipeCardView: View {
    @Environment(\.modelContext) var modelContext
    let recipe: Recipe
    var body: some View {
        HStack(spacing: 10) {
            if let imageData = recipe.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .square()
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size * 0.25
                    }
                    .cornerRadius(10)
            }
                
            VStack(alignment: .leading, spacing: 20) {
                Text(recipe.title)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock")
                        Text("\(recipe.readyInMinutes) mins")
                    }
                    Text("Servings: \(recipe.servings)")
                }
                .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                recipe.isFavorite.toggle()
                try? modelContext.save()
            } label: {
                Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(recipe.isFavorite ? .red : .black)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    let uiImage = UIImage(named: "pancakes")
    let imageData = uiImage?.pngData()
    let recipe = Recipe(title: "Fluffy Pancakes", image: imageData, servings: 4, readyInMinutes: 30, analyzedInstructions: [], extendedIngredients: [], sourceUrl: "https://www.test.com")
    RecipeCardView(recipe: recipe)
}
