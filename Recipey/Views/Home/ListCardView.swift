//
//  CategoryCardView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/16/25.
//

import SwiftUI

struct ListCardView: View {
    let list: RecipeList
    var onRequestDelete: (UUID) -> Void
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let imageData = list.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
            }
            
            HStack {
                Text(list.title)
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .glassEffect(.regular, in: .rect(cornerRadius: 10))

                Spacer()
            }
            .padding([.leading, .bottom, .trailing], 8)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(list.title) list")
        .accessibilityHint("View recipes")
        .contextMenu {
            Button("Rename", systemImage: "pencil") {
                // rename list
            }
            Button(role: .destructive) {
                onRequestDelete(list.id)
            } label: {
                Label("Delete List", systemImage: "trash")
            }
        }
    }
}

#Preview {
    let uiImage = UIImage(named: "pancakes")
    let imageData = uiImage?.pngData()
    ListCardView(list: RecipeList(title: "Breakfast", image: imageData), onRequestDelete: { _ in })
}
