//
//  ShoppingList.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/11/21.
//

import Foundation

class ShoppingList {
    
    var ingredients: [String]
    
    init(ingredients: [String]) {
        self.ingredients = ingredients
    }
}

extension ShoppingList {
    
    convenience init?(recipe: Recipe) {
        
        let ingredients = recipe.ingredients
        
        self.init(ingredients: ingredients)
    }
}
