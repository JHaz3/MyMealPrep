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
}
struct RecipeContainer: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let label: String
    let image: String?
    let directions: String
    let ingredients: [String]
    let yield: Int
    let totalTime: Int
    var users: [String]?
    var uid: String?
    var isChecked: Bool = false
    
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
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uid == rhs.uid
    }
}
