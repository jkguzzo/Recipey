//
//  RecipeDetailView.swift
//  Recipey
//
//  Created by Julia Guzzo on 1/10/26.
//

import SwiftData
import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    let recipe: Recipe
    
    var body: some View {
        GeometryReader { container in
            ScrollView {
                VStack(spacing: 20) {
                    GeometryReader { geo in
                        ZStack(alignment: .bottomLeading) {
                            if let imageData = recipe.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .clipped()
                                    .ignoresSafeArea(edges: .top)
                            }
                            HStack {
                                Text(recipe.title)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 8)
                                    .glassEffect(.regular, in: .rect(cornerRadius: 10))
                                Spacer()
                                Button {
                                    recipe.isFavorite.toggle()
                                    try? modelContext.save()
                                } label: {
                                    Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                                        .font(.title3)
                                        .foregroundStyle(recipe.isFavorite ? .red : colorScheme == .light ? .black :  .white)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 8)
                                        .glassEffect(.regular, in: .rect(cornerRadius: 10))

                                }
                            }
                            .padding([.leading, .bottom, .trailing], 8)
                        }
                        .frame(height: geo.size.height)
                    }
                    .frame(height: container.size.height * 0.3)

                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Servings: \(recipe.servings)")
                            Spacer()
                            Label("\(recipe.readyInMinutes) mins", systemImage: "clock")
                        }
                        Divider()
                            .overlay(colorScheme == .light ? .black : .white)
                        Text("Ingredients")
                            .font(.title3)
                            .fontWeight(.semibold)
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(recipe.extendedIngredients, id: \.id) { ingredient in
                                Text("• \(ingredient.original)")
                            }
                        }
                        .padding(.leading, 20)
                        Divider()
                            .overlay(colorScheme == .light ? .black : .white)
                        Text("Instructions")
                            .font(.title3)
                            .fontWeight(.semibold)
                        VStack(spacing: 8) {
                            Text("1. Step 1")
                            Text("2. Step 2")
                            Text("3. Step 3")
                            Text("4. Step 4")
                            Text("5. Step 5")
                            Text("6. Step 6")
                            Text("7. Step 7")
                        }
                        .padding(.leading, 20)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    let uiImage = UIImage(named: "pancakes")
    let imageData = uiImage?.pngData()
    let measure = Measure(amount: 2.0, unitLong: "cups", unitShort: "cup")
    let measureOption = MeasureOption(metric: measure, us: measure)
    let ingredient = Ingredient(id: 1, measures: measureOption, unit: "cups", original: "2 1/4 cup flour")
    let recipe = Recipe(title: "Fluffy Pancakes", image: imageData, servings: 4, readyInMinutes: 20, instructions: "", extendedIngredients: [ingredient], sourceUrl: "example.com")
    
    RecipeDetailView(recipe: recipe)
}

