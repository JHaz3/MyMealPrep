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
    static private let baseURL = URL(string: "https://api.edamam.com/search")
    static private let appID = "app_id"
    static private let appIDValue = "d4009615"
    static private let appKey = "app_key"
    static private let appKeyValue = "48c7deafe28862ded87866c21e220a3f"
    static private let searchKey = "q"
    
    static var recipes: [Recipe] = []
    static var savedRecipes: [Recipe] = []
    static var randomRecipe: Recipe?
    
    static func fetchRecipe(searchTerm: String, completion: @escaping (Result<[Recipe], RecipeError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: searchKey, value: searchTerm),
            URLQueryItem(name: appID, value: appIDValue),
            URLQueryItem(name: appKey, value: appKeyValue)
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
    
    static func fetchImage(for recipe: Recipe, completion: @escaping (Result<UIImage, RecipeError>) -> Void) {
        
        guard let recipeImageURL = URL(string: recipe.image ?? "\(print("Image Not Found"))") else {
            return completion(.failure(.noData)) }
        
        URLSession.shared.dataTask(with: recipeImageURL) { (data, _, error) in
            if let error = error {
                completion(.failure(.thrown(error)))
            }
            guard let data = data else {
                return completion(.failure(.noData))
            }
            guard let image = UIImage(data: data) else {
                return completion(.failure(.noData))
            }
            completion(.success(image))
        }.resume()
    }
    
    static func toggleBoxChecked(recipe: inout Recipe) {
        recipe.isChecked.toggle()
    }
    
    static func fetchRandomRecipe(completion: @escaping (Result<Recipe, RecipeError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: searchKey, value: "random"),
            URLQueryItem(name: appID, value: appIDValue),
            URLQueryItem(name: appKey, value: appKeyValue)
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
                let recipe = recipes.randomElement()!
                self.randomRecipe = recipe
                return completion(.success(recipe))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
                return completion(.failure(.noData))
            }
        }.resume()
    }
}// End of Class
