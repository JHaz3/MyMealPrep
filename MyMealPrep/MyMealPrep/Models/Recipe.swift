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
    var users: [String]?
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
        case users
        case uid
    }
    
    init(label: String, image: String?, directions: String, ingredients: [String], yield: Int, totalTime: Int, users: [String]?, uid: String?, isChecked: Bool, dateToEat: Date) {
        self.label = label
        self.image = image
        self.directions = directions
        self.ingredients = ingredients
        self.yield = yield
        self.totalTime = totalTime
        self.users = users
        self.uid = uid
        self.isChecked = isChecked
        self.dateToEat = dateToEat
    }
    
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uid == rhs.uid
            && lhs.isChecked == rhs.isChecked
            && lhs.label == rhs.label
            && lhs.image == rhs.image
    }
}
