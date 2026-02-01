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
        VStack(spacing: 0) {
            if let imageData = recipe.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 125)
                    .clipped()
            } else {
                Color.secondary.opacity(0.15)
                    .frame(height: 125)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(recipe.title)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .truncationMode(.tail)
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
                    .lineLimit(1)

                Label("\(recipe.readyInMinutes) mins", systemImage: "clock")
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .glassEffect()
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
    let recipe = Recipe(title: "Fluffy Pancakes", image: imageData, servings: 4, readyInMinutes: 20, analyzedInstructions: [], extendedIngredients: [], sourceUrl: "example.com")
    ListCardSearchView(recipe: recipe)
}
