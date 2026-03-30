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
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(isSelected(list) ? "\(list.title), selected" : "\(list.title), not selected")
                    .accessibilityHint("Tap to \(isSelected(list) ? "deselect" : "select") \(list.title)")
                    .accessibilityAddTraits(.isButton)
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
            .accessibilityLabel("Add Recipe")
            .accessibilityHint(selectedListIDs.isEmpty ? "Disabled. Select at least one list first" : "Add recipe to all selected lists")
            .accessibilityValue("\(selectedListIDs.count) list\(selectedListIDs.count == 1 ? "" : "s") selected")
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
            dismiss()
        } catch {
            print("Failed to save recipe to list(s): \(error)")
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
