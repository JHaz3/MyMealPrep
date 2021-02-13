//
//  MealPrep.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/11/21.
//

import Foundation

class MealPlan {
    
    var mealPlanName: String
    var mealPlanDates: [Date]
   // var startDate: Date
   // var endDate: Date
    var recipes: [Recipe]
    
    init(mealPlanName: String = String(), mealPlanDates: [Date], recipes: [Recipe]) {
        self.mealPlanName = mealPlanName
       // self.startDate = startDate
       // self.endDate = endDate
        self.recipes = recipes
        self.mealPlanDates = mealPlanDates
    }
    
}

extension MealPlan: Equatable {
    static func == (lhs: MealPlan, rhs: MealPlan) -> Bool {
        return //lhs.startDate == rhs.startDate
            //&& lhs.endDate == rhs.endDate
            lhs.recipes == rhs.recipes
            && lhs.mealPlanName == rhs.mealPlanName
            && lhs.mealPlanDates == rhs.mealPlanDates
    }
}
