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
    static private let appIDValue = "f46dc9e4"
    static private let appKey = "app_key"
    static private let appKeyValue = "157465b7f776b7f2a6cf93b71f8aab4b"
    static private let searchKey = "q"
    
    static let shared: RecipeController = RecipeController()
    static var recipes: [Recipe] = []
    var savedRecipes: [Recipe] = [] {
        didSet {
            saveToPersistentStorage()
        }
    }
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
    
    
   static func updateDateToEat(date: Date, recipe: Recipe) {
        recipe.dateToEat = date
        
        
    }
    
    static func fetchRandomRecipe(searchTerm: String, completion: @escaping (Result<Recipe, RecipeError>) -> Void) {
        
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
                let randomRecipe = recipes.randomElement()!
                return completion(.success(randomRecipe))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
                return completion(.failure(.noData))
            }
        }.resume()
    }
    
    func deleteRecipe(recipe: Recipe) {
        guard let index = savedRecipes.firstIndex(of: recipe) else { return }
        savedRecipes.remove(at: index)
        UserController.shared.deleteRecipe(recipe: recipe)
        saveToPersistentStorage()
    }
    
    func toggleBoxChecked(recipe: Recipe) {
        recipe.isChecked.toggle()
    }
    
    //MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "MyMealPrep.json"
        let documentDirectory = urls[0]
        let documentsDirectoryURL = documentDirectory.appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    func saveToPersistentStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(savedRecipes)
            try data.write(to: fileURL())
        } catch let error {
            print("There was an error saving to persistent storage: \(error)")
        }
    }
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedData = try jsonDecoder.decode([Recipe].self, from: data)
            self.savedRecipes = decodedData
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
    }
    
}// End of Class
