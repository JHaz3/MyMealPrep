//
//  MealPrep.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/11/21.
//

import Foundation

class MealPlan {
    
    var startDate: Date
    var endDate: Date
    var recipes: [Recipe]
    
    init(startDate: Date = Date(), endDate: Date = Date(), recipes: [Recipe]) {
        self.startDate = startDate
        self.endDate = endDate
        self.recipes = recipes
    }
    
}

extension MealPlan: Equatable {
    static func == (lhs: MealPlan, rhs: MealPlan) -> Bool {
        return lhs.startDate == rhs.startDate
            && lhs.endDate == rhs.endDate
            && lhs.recipes == rhs.recipes
    }
}
