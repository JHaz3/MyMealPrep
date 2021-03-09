//
//  MealPrep.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/11/21.
//

import Foundation
import Firebase

class MealPlan: Codable {
    
    var mealPlanName: String
    var startDate: Date
    var endDate: Date
    var recipes: [Recipe]
    var authorID: String?
    var mealPlanUID: String?
    var encodedRecipes: [[String : Any]] {
        get {
            var data = [[String : Any]]()
            
            for recipe in recipes {
                let recipeUID = UUID().uuidString
                let recipeAuthorID = UserController.shared.currentUser?.uuid
                let x: [String : Any] = [
                    Constants.recipeLabel : recipe.label,
                    Constants.recipeImage : recipe.image ?? "",
                    Constants.recipeDirections : recipe.directions,
                    Constants.recipeIngredients : recipe.ingredients,
                    Constants.recipeYield : recipe.yield,
                    Constants.recipeTotalTime : recipe.totalTime,
                    Constants.recipeUID : recipeUID,
                    Constants.recipeIsChecked : recipe.isChecked,
                    Constants.dateToEat : recipe.dateToEat,
                    Constants.authorID : recipeAuthorID ?? ""
                ]
                data.append(x)
            }
            return data
        }
    }
    
    init(mealPlanName: String = "", startDate: Date = Date(), endDate: Date = Date(), recipes: [Recipe] = [], authorID: String = UserController.shared.currentUser?.uuid ?? "", mealPlanUID: String = UUID().uuidString) {
        self.mealPlanName = mealPlanName
        self.startDate = startDate
        self.endDate = endDate
        self.recipes = recipes
        self.authorID = authorID
        self.mealPlanUID = mealPlanUID
    }
    
    convenience init?(document: [String : Any]) {
        guard let mealPLanName = document[Constants.mealPlanName] as? String,
              let startDate = document[Constants.startDate] as? Timestamp,
              let endDate = document[Constants.endDate] as? Timestamp,
              let recipes = document[Constants.mealPlanRecipes] as? [Recipe],
              let authorID = document[Constants.authorID] as? String,
              let mealPlanUID = document[Constants.mealPlanUID] as? String else {
            return nil
        }
        
        self.init(mealPlanName: mealPLanName, startDate: startDate.dateValue(), endDate: endDate.dateValue(), recipes: recipes, authorID: authorID, mealPlanUID: mealPlanUID)
    }
    
}

extension MealPlan: Equatable {
    static func == (lhs: MealPlan, rhs: MealPlan) -> Bool {
        return lhs.startDate == rhs.startDate
            && lhs.endDate == rhs.endDate
            && lhs.recipes == rhs.recipes
            && lhs.mealPlanName == rhs.mealPlanName
            && lhs.authorID == rhs.authorID
            && lhs.mealPlanUID == rhs.mealPlanUID
    }
}
