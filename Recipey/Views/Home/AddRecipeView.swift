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
    @State var url: String = ""
    @State var isLoading: Bool = false

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
                            isLoading = true
                            if let recipeDTO = try await RecipeService.shared.getRecipe(for: url) {
                                var imageData: Data? = nil
                                if let imageURL = URL(string: recipeDTO.image) {
                                    let (data, _) = try await URLSession.shared.data(from: imageURL)
                                    imageData = data
                                }
                                isLoading = false

                                let recipe = Recipe(from: recipeDTO, imageData: imageData)
                                modelContext.insert(recipe)
                                dismiss()
                            }
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
}

#Preview {
    AddRecipeView()
}
