//
//  ListCardSearchView.swift
//  Recipey
//
//  Created by Julia Guzzo on 1/11/26.
//

import SwiftData
import SwiftUI
import UIKit

struct ListCardSearchView: View {
    @Environment(\.modelContext) var modelContext
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // TODO: image doesn't look right with vertical images
            if let imageData = recipe.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(recipe.title)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        recipe.isFavorite.toggle()
                        try? modelContext.save()
                    } label: {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(recipe.isFavorite ? .red : .black)
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(.plain)
                }
                Text("Servings: \(recipe.servings)")
                    .foregroundStyle(.secondary)
                Label("\(recipe.readyInMinutes) mins", systemImage: "clock")
                    .foregroundStyle(.secondary)

            }
            .padding(.horizontal)
        }
        .cornerRadius(10)
        .contextMenu {
            Button(role: .destructive) {
                modelContext.delete(recipe)
                try? modelContext.save()
            } label: {
                Label("Delete Recipe", systemImage: "trash")
            }
        }
    }
}

#Preview {
    let uiImage = UIImage(named: "pancakes")
    let imageData = uiImage?.pngData()
    let recipe = Recipe(title: "Fluffy Pancakes", image: imageData, servings: 4, readyInMinutes: 20, instructions: "", extendedIngredients: [], sourceUrl: "example.com")
    ListCardSearchView(recipe: recipe)
}
