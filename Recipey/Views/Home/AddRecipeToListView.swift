//
//  AddRecipeToListView.swift
//  Recipey
//
//  Created by Julia Guzzo on 2/2/26.
//

import SwiftData
import SwiftUI

struct AddRecipeToListView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var recipe: Recipe
    @Query var lists: [RecipeList]
    
    @State private var selectedListIDs: Set<RecipeList.ID> = []
    var body: some View {
        VStack(spacing: 25) {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(lists.sorted(by: {$0.title < $1.title})) { list in
                    HStack {
                        Button {
                            toggleSelection(for: list)
                        } label: {
                            Image(systemName: isSelected(list) ? "checkmark.square.fill" : "square")
                                .font(.title3)
                        }
                        Text(list.title)
                    }
                }
                .padding(.horizontal)
            }
            Button {
                addRecipeToSelectedLists()
            } label: {
                Text("Add Recipe")
                    .padding()
                    .glassEffect()
            }
            .disabled(selectedListIDs.isEmpty)
        }
        .buttonStyle(.plain)
    }
    
    private func isSelected(_ list: RecipeList) -> Bool {
        selectedListIDs.contains(list.id)
    }

    private func toggleSelection(for list: RecipeList) {
        if isSelected(list) {
            selectedListIDs.remove(list.id)
        } else {
            selectedListIDs.insert(list.id)
        }
    }
    
    private func addRecipeToSelectedLists() {
        for list in lists where selectedListIDs.contains(list.id) {
            if !list.recipes.contains(where: { $0.id == recipe.id }) {
                list.recipes.append(recipe)
            }
        }

        do {
            try modelContext.save()
            dismiss() // optionally dismiss after success
        } catch {
            // Handle error (e.g., show an alert)
            // For now, you could log or present a simple message
            // print(\"Failed to save: \\(error)\")
        }
    }
}

#Preview {
    let container = inMemoryContainerForPreviews()
    let uiImage = UIImage(named: "pancakes")
    let imageData = uiImage?.pngData()
    let recipe = Recipe(title: "Fluffy Pancakes", image: imageData, servings: 4, readyInMinutes: 30, analyzedInstructions: [], extendedIngredients: [], sourceUrl: "https://www.test.com")
    AddRecipeToListView(recipe: recipe)
        .modelContainer(container)
}
