//
//  ShoppingListController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/25/21.
//

import Foundation

class ShoppingListController {
    
    // MARK: - Properties
    static let shared: ShoppingListController = ShoppingListController()
    var listItems: [String] = []
    
    // MARK: - CRUD
    func addItemToShoppingList(item: String) {
        listItems.append(item)
    }
    
    func addMealPlanRecipesIngredients(mealPlan: MealPlan) {
        for recipe in mealPlan.recipes {
            self.addRecipeIngredients(recipe: recipe)
        }
    }
    
    func addRecipeIngredients(recipe: Recipe) {
        for ingredient in recipe.ingredients {
            self.listItems.append(ingredient)
        }
    }
    
    //MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "MyMealPrep.json"
        let documentDirectory = urls[0]
        let documentsDirectoryURL = documentDirectory.appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    func saveToPersistentStorage(listItems: [String]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(listItems)
            try data.write(to: fileURL())
        } catch let error {
            print("There was an error saving to persistent storage: \(error)")
        }
    }
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedData = try jsonDecoder.decode([String].self, from: data)
            self.listItems = decodedData
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
    }
    
}// End of Class
