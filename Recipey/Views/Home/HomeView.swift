//
//  HomeView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/16/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query var lists: [RecipeList]

    @State private var deleteListConfirmation: Bool = false
    @State private var pendingDeleteListID: UUID? = nil
    @State private var showingAddOverlay: Bool = false
    @State private var showingCreateList: Bool = false
    @State private var showingAddRecipe: Bool = false

    var columns: [[RecipeList]] {
        var cols = Array(repeating: [RecipeList](), count: 2)
        for (index, list) in lists.enumerated() {
            cols[index % 2].append(list)
        }
        return cols
    }

    var body: some View {
        ZStack {
            NavigationStack {
                if lists.isEmpty {
                    ContentUnavailableView("No Lists Yet", systemImage: "menucard", description: Text("Create a list to see it displayed here"))
                        .accessibilityLabel("No lists yet. Tap the plus button to create your first list")
                }
                ScrollView {
                    HStack(alignment: .top, spacing: 15) {
                        ForEach(0..<columns.count, id: \.self) { columnIndex in
                            LazyVStack(spacing: 15) {
                                ForEach(columns[columnIndex]) { list in
                                    NavigationLink {
                                        ListDetailView(list: list)
                                    } label: {
                                        ListCardView(list: list, onRequestDelete: { listID in
                                            pendingDeleteListID = listID
                                            deleteListConfirmation = true
                                        })
                                    }
                                }
                            }
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel("Recipe lists")
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .overlay {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                showingAddOverlay = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .padding(12)
                                    .glassEffect()
                            }
                            .accessibilityLabel("Add")
                            .accessibilityHint("Create a new list or add a recipe")
                            .accessibilityAddTraits(.isButton)
                            .popover(isPresented: $showingAddOverlay, attachmentAnchor: .point(.center), arrowEdge: .bottom) {
                                VStack(spacing: 12) {
                                    Button {
                                        showingCreateList = true
                                    } label: {
                                        Text("New List")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.primary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .glassEffect()
                                            .padding(.horizontal)
                                    }
                                    Button {
                                        showingAddRecipe = true
                                    } label: {
                                        Text("New Recipe")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.primary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .glassEffect()
                                            .padding(.horizontal)
                                    }
                                }
                                .frame(width: 200, height: 125)
                                .presentationCompactAdaptation(.popover)
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .fullScreenCover(isPresented: $showingCreateList) {
                    CreateListView()
                }
                .fullScreenCover(isPresented: $showingAddRecipe) {
                    AddRecipeView()
                }
                .navigationTitle("My Lists")
                .buttonStyle(.plain)
                .alert("Delete List?", isPresented: $deleteListConfirmation) {
                    Button("Delete", role: .destructive) {
                        deleteList()
                    }
                    Button("Cancel", role: .cancel) {
                        pendingDeleteListID = nil
                    }
                } message: {
                    Text("This action cannot be undone.")
                }
            }
        }
    }

    private func deleteList() {
        guard let id = pendingDeleteListID else { return }
        if let target = lists.first(where: { $0.id == id }) {
            modelContext.delete(target)
            do {
                try modelContext.save()
            } catch {
                // handle error
            }
        }
        pendingDeleteListID = nil
    }
}

#Preview {
    let container = inMemoryContainerForPreviews()
    HomeView()
        .modelContainer(container)
}
