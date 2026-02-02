//
//  AddRecipeView.swift
//  Recipey
//
//  Created by Julia Guzzo on 1/11/26.
//

import SwiftData
import SwiftUI

struct AddRecipeView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var url: String = ""
    @State private var isLoading: Bool = false
    @State private var fetchedRecipe: Recipe? = nil
    @State private var navigateToDetail: Bool = false

    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView()
            } else {
                VStack(spacing: 35) {
                    Spacer()

                    TextField("Enter your title...", text: $url)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary, lineWidth: 1)
                        )

                    Button {
                        Task {
                            await fetchRecipeAndNavigate()
                        }
                    } label: {
                        Text("Add Recipe")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.primary, lineWidth: 1)
                            )
                    }
                    .disabled(url.isEmpty)

                    Spacer()
                }
                .navigationDestination(isPresented: $navigateToDetail) {
                    if let recipe = fetchedRecipe {
                        RecipeDetailView(recipe: recipe)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
            }
        }
    }
    
    private func fetchRecipeAndNavigate() async {
        isLoading = true
        defer { isLoading = false }
        do {
            guard let recipeDTO = try await RecipeService.shared.getRecipe(for: url) else { return }
            var imageData: Data? = nil
            if let imageURL = URL(string: recipeDTO.image) {
                let (data, _) = try await URLSession.shared.data(from: imageURL)
                imageData = data
            }
            let recipe = Recipe(from: recipeDTO, imageData: imageData)
            // Do NOT insert yet. Let the user choose lists in the next step.
            self.fetchedRecipe = recipe
            self.navigateToDetail = true
        } catch {
            // Handle error (alert/toast)
        }
    }
}

#Preview {
    AddRecipeView()
}
