//
//  SearchView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/26/25.
//

import SwiftData
import SwiftUI
import UIKit

struct SearchView: View {
    @Query var lists: [RecipeList]
    @Query var recipes: [Recipe]
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 50) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Lists")
                        .font(.title).bold()
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(lists) { list in
                                NavigationLink {
                                    ListDetailView(list: list)
                                } label: {
                                    ListCardView(list: list, onRequestDelete: { _ in })
                                    
                                }
                                
                            }
                        }
                        .frame(height: 200)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recipes")
                        .font(.title).bold()
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 16) {
                            ForEach(recipes, id: \.self) { recipe in
                                NavigationLink {
                                    RecipeDetailView(recipe: recipe)
                                } label: {
                                    ListCardSearchView(recipe: recipe)
                                        .frame(maxWidth: .infinity)

                                }
                            }
                        }
                    }

                }
            }
            .padding(.horizontal)
        }
        .searchable(text: $searchText)
        .buttonStyle(.plain)
    }
}

#Preview {
    let container = inMemoryContainerForPreviews()
    SearchView()
        .modelContainer(container)
}
