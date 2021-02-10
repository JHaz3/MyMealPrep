//
//  RecipeController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/10/21.
//

import Foundation
import Firebase

class RecipeController {
    
    // MARK: - Properties
    static private let baseURL = URL(string: "https:api.edamam.com/search")
    static private let appID = "app_id"
    static private let appIDValue = "d4009615"
    static private let appKey = "app_key"
    static private let appKeyValue = "48c7deafe28862ded87866c21e220a3f"
    static private let searchKey = "q"
    
    static private var recipes: [Recipe] = []
    
    static func fetchRecipe(searchTerm: String, completion: @escaping (Result<[Recipe], RecipeError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: appID, value: appIDValue),
            URLQueryItem(name: appKey, value: appKeyValue),
            URLQueryItem(name: searchKey, value: searchTerm)
        ]
        
        guard let finalURL = urlComponents?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
                return completion(.failure(.noData))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                
                let recipeContainer = try JSONDecoder().decode(TopLevelObject.self, from: data).hits
                let recipes = recipeContainer.compactMap({ $0.recipe })
                self.recipes = recipes
                return completion(.success(recipes))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
                return completion(.failure(.noData))
            }
        }.resume()
    }
    
    
}// End of Class
