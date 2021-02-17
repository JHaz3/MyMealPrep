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
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    
    
    // MARK: - Actions
    @IBAction func assignDateButtonTapped(_ sender: Any) {
        
        
    }
    
    
    // MARK: -Methods
    func updateViews() {
        guard let recipe = recipe else { return }
        recipeNameLabel.text = recipe.label
        
        RecipeController.fetchImage(for: recipe) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}// End of Class
