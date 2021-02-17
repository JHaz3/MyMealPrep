//
//  MealPlanListTableViewCell.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/12/21.
//

import UIKit

class MealPlanListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var mealPlanImage: UIImageView!
    @IBOutlet weak var mealPlanNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    // MARK: - Properties
    var mealPlan: MealPlan? {
        didSet {
            guard let mealPlan = mealPlan else { return }
            mealPlanNameLabel.text = mealPlan.mealPlanName
            startDateLabel.text = "\(mealPlan.startDate)"
            endDateLabel.text = "\(mealPlan.endDate)"
        }
    }


} //End of Class
