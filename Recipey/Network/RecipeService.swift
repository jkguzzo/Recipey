//
//  RecipeService.swift
//  Recipey
//
//  Created by Julia Guzzo on 1/11/26.
//

import Foundation
import Observation

@Observable
class RecipeService {
    
    static let shared = RecipeService()
    
    func getRecipe(for url: String) async throws -> RecipeDTO? {
        let apiKey = "0e20486ec4914bc0a4cd15a50a508492"
        let endpoint = "https://api.spoonacular.com/recipes/extract?url=\(url)"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print("Data: \(data)")
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid response from API (status code other than 200)")
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoder = JSONDecoder()
            let recipeDTO = try decoder.decode(RecipeDTO.self, from: data)
            print("RecipeDTO: \(recipeDTO)")
            return recipeDTO
        } catch {
            print("Failed to decode JSON into RecipeDTO")
            throw URLError(.cannotDecodeRawData)
        }
    }
}
