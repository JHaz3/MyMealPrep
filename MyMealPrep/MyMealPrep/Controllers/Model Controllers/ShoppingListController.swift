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
    var listItems: [ShoppingList] = []
    
    // MARK: - CRUD
    func addItemToShoppingList(with item: String) {
        let ingredient = ShoppingList(item: item)
        if !listItems.isEmpty {
            listItems.insert(ingredient, at: 0)
        } else {
            listItems.append(ingredient)
        }
        saveToPersistentStorage(listItems: listItems)
    }
    
    func addMealPlanRecipesIngredients(mealPlan: MealPlan) {
        for recipe in mealPlan.recipes {
            self.addRecipeIngredients(recipe: recipe)
        }
    }
    
    func addRecipeIngredients(recipe: Recipe) {
        for ingredient in recipe.ingredients {
            if !listItems.isEmpty {
                self.listItems.insert(ShoppingList(item: ingredient), at: 0)
            } else {
                self.listItems.append(ShoppingList(item: ingredient))
            }
            saveToPersistentStorage(listItems: listItems)
        }
    }
    
    func deleteItem(item: ShoppingList) {
        guard let index = listItems.firstIndex(of: item) else { return }
        listItems.remove(at: index)
        saveToPersistentStorage(listItems: listItems)
    }
    
    func clearListItems() {
        listItems.removeAll()
        saveToPersistentStorage(listItems: listItems)
    }
    
    func updateListItem(listItem: ShoppingList, itemName: String) {
        listItem.item = itemName
        saveToPersistentStorage(listItems: listItems)
    }
    
    func toggleItemChecked(ingredient: ShoppingList) {
        ingredient.isChecked.toggle()
        saveToPersistentStorage(listItems: listItems)
    }
    
    //MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "MyMealPrep.json"
        let documentDirectory = urls[0]
        let documentsDirectoryURL = documentDirectory.appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    func saveToPersistentStorage(listItems: [ShoppingList]) {
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
            let decodedData = try jsonDecoder.decode([ShoppingList].self, from: data)
            self.listItems = decodedData
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
    }
    
}// End of Class
