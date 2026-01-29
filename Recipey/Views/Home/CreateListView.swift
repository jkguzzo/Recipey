//
//  CreateListView.swift
//  Recipey
//
//  Created by Julia Guzzo on 12/16/25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct CreateListView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var selectedPhoto: PhotosPickerItem?
    @State var title: String = ""
    @State var selectedPhotoData: Data?

    var body: some View {
        NavigationStack {
            VStack(spacing: 35) {
                Spacer()
                VStack {
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared())
                    {
                        if let image = selectedPhotoData, let uiImage = UIImage(data: image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 175)
                                .cornerRadius(10)
                        } else {
                            VStack {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.secondary)
                                    .font(.largeTitle)
                                Text("Add Photo")
                            }
                            .padding(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.primary, lineWidth: 1)
                            )
                        }
                    }
                }
                
                TextField("Enter your title...", text: $title)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 1)
                    )
                
                Button {
                    if !title.isEmpty {
                        let list = RecipeList(title: title, image: selectedPhotoData)
                        modelContext.insert(list)
                        // bad practice probably
                        try? modelContext.save()
                        dismiss()
                    } else {
                        // error
                    }
                } label: {
                    Text("Create List")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary, lineWidth: 1)
                        )
                }
                .disabled(title.isEmpty || selectedPhotoData == nil)
                
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
            .buttonStyle(.plain)
            .padding(.horizontal)
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }
}

#Preview {
    CreateListView()
}
