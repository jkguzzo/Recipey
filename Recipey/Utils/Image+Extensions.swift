//
//  Image+Extensions.swift
//  Recipey
//
//  Created by Julia Guzzo on 1/10/26.
//

import SwiftUI

// creates .square modifier to be used on Images
extension Image {
    func square() -> some View {
        Rectangle()
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                self
                    .resizable()
                    .scaledToFill()
            )
            .clipShape(Rectangle())
    }
}
