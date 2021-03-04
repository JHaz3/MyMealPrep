//
//  Recipe.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/10/21.
//

import Foundation

struct TopLevelObject: Codable {
    let searchTerm: String
    let hits: [RecipeContainer]
    
    enum CodingKeys: String, CodingKey {
        case searchTerm = "q"
        case hits
    }
}
struct RecipeContainer: Codable {
    let recipe: Recipe
}

class Recipe: Codable {
    let label: String
    let image: String?
    let directions: String
    let ingredients: [String]
    let yield: Int
    let totalTime: Int
    var uid: String?
    var isChecked: Bool = false
    var dateToEat: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case label
        case directions = "url"
        case image
        case ingredients = "ingredientLines"
        case yield
        case totalTime
        case uid
    }
    
    init(label: String, image: String?, directions: String, ingredients: [String], yield: Int, totalTime: Int, uid: String = UUID().uuidString, isChecked: Bool, dateToEat: Date) {
        self.label = label
        self.image = image
        self.directions = directions
        self.ingredients = ingredients
        self.yield = yield
        self.totalTime = totalTime
        self.uid = uid
        self.isChecked = isChecked
        self.dateToEat = dateToEat
    }
    
}// End of Class

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uid == rhs.uid
            && lhs.isChecked == rhs.isChecked
            && lhs.label == rhs.label
            && lhs.image == rhs.image
            && lhs.directions == rhs.directions
            && lhs.ingredients == rhs.ingredients
            && lhs.yield == rhs.yield
            && lhs.totalTime == rhs.totalTime
            && lhs.dateToEat == rhs.dateToEat
    }
}

extension Recipe {
    convenience init?(dictionary: [String : Any]) {
        guard let label = dictionary[Constants.recipeLabel] as? String,
              let image = dictionary[Constants.recipeImage] as? String,
              let directions = dictionary[Constants.recipeDirections] as? String,
              let ingredients = dictionary[Constants.recipeIngredients] as? [String],
              let yield = dictionary[Constants.recipeYield] as? Int,
              let totalTime = dictionary[Constants.recipeTotalTime] as? Int,
              let uid = dictionary[Constants.recipeUID] as? String,
              let isChecked = dictionary[Constants.recipeIsChecked] as? Bool,
              let dateToEat = dictionary[Constants.dateToEat] as? Date
        else { return nil}
        self.init(label: label, image: image, directions: directions, ingredients: ingredients, yield: yield, totalTime: totalTime, uid: uid, isChecked: isChecked, dateToEat: dateToEat)
    }
}
