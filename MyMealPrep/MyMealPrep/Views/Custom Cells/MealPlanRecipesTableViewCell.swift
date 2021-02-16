//
//  MealPlanRecipesTableViewCell.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/15/21.
//

import UIKit

// MARK: - Protocols
protocol MealPLanRecipesTableViewCellDelegate: class {
    func assignDateToEat(_ sender: MealPlanRecipesTableViewCell)
    
}


class MealPlanRecipesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var assignDateButton: UIButton!
    
    // MARK: - Properties
    var recipe: Recipe?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK: - Actions
    @IBAction func assignDateButtonTapped(_ sender: Any) {
        
        
    }
    
    
    // MARK: -Methods
}
