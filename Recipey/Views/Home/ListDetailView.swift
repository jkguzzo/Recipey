//
//  ListDetailView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/17/25.
//

import SwiftData
import SwiftUI

struct ListDetailView: View {
    @Environment(\.modelContext) var modelContext
    var list: RecipeList
    @State private var showRenamePopover: Bool = false
    @State private var newTitle: String = ""
    var body: some View {
            VStack {
                if list.recipes.count == 0 {
                    ContentUnavailableView("No Recipes Yet", systemImage: "fork.knife.circle.fill", description: Text("Add a recipe to this list to see it displayed here"))
                } else {
                    // TODO: show Recipes here
                }
            }
            .navigationTitle(list.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("", systemImage: "pencil") {
                        Button {
                            showRenamePopover = true
                        } label: {
                            Text("Rename List")
                        }
                    }
                    .popover(isPresented: $showRenamePopover, attachmentAnchor: .point(.trailing), arrowEdge: .top) {
                        HStack {
                            TextField(list.title, text: $newTitle)
                            Button {
                                showRenamePopover = false
                                renameList()
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        .frame(width: 250, height: 75)
                        .presentationCompactAdaptation(.popover)
                        
                    }
                }
            }
    }
    
    func renameList() {
        // TODO: add validation to make sure title is unique
        if !newTitle.isEmpty {
            list.title = newTitle
            try? modelContext.save()
        }
    }
}

#Preview {
    NavigationStack {
        let recipeList = RecipeList(title: "Breakfast", image: nil)
        ListDetailView(list: recipeList)
    }
}

