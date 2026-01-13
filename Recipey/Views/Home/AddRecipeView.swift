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

    var body: some View {
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
                    if let recipeDTO = try await RecipeService.shared.getRecipe(for: url) {
                        var imageData: Data? = nil
                        if let imageURL = URL(string: recipeDTO.image) {
                            let (data, _) = try await URLSession.shared.data(from: imageURL)
                            imageData = data
                        }
                        
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
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                        .font(.title3)
                        .padding(10)
                        .background {
                            Circle()
                                .stroke(.primary)
                        }
                    }
                }
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

#Preview {
    AddRecipeView()
}
