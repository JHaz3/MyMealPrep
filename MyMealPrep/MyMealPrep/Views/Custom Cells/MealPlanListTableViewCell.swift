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
    
    // MARK: - ToDo: Come back to this after finishing Select Date View
    // MARK: - Properties
    var mealPlan: MealPlan? {
        didSet {
            guard let mealPlan = mealPlan else { return }
            mealPlanNameLabel.text = mealPlan.mealPlanName
            
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

} //End of Class
