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
                                withAnimation(.none) { showingAddOverlay = true }
                            } label: {
                                // TODO: change to be glass button
                                Image(systemName: "plus")
                                    .font(.title)
                                    .padding(10)
                                    .background {
                                        Circle()
                                            .stroke(.primary)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .fullScreenCover(isPresented: $showingCreateList) {
                    CreateListView(showingAddOverlay: $showingAddOverlay)
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

            if showingAddOverlay {
                // Dimming background that dismisses on tap
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.none) { showingAddOverlay = false }
                    }

                AddOverlay(showingAddOverlay: $showingAddOverlay, showingCreateList: $showingCreateList, showingAddRecipe: $showingAddRecipe)
                    .frame(width: 220)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemBackground))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
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

struct AddOverlay: View {
    @Binding var showingAddOverlay: Bool
    @Binding var showingCreateList: Bool
    @Binding var showingAddRecipe: Bool
    var body: some View {
        VStack(spacing: 20) {
            Button {
                showingCreateList = true
                showingAddOverlay = false
            } label: {
                Text("New List")
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 1)
                    )
            }

            Button {
                showingAddRecipe = true
                showingAddOverlay = false
            } label: {
                Text("New Recipe")
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity) // expand to container width
                    .padding(.vertical, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 1)
                    )
            }
        }
        .padding(20)
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
