//
//  RecipeBookTableViewCell.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 2/16/21.
//

import UIKit

class RecipeBookTableViewCell: UITableViewCell {
    
    // Mark: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeYieldLabel: UILabel!
    @IBOutlet weak var recipeCookTimeLabel: UILabel!
    
    // Mark: - Properties
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else {return}
            recipeNameLabel.text = recipe.label
            recipeYieldLabel.text = "Yield: \(recipe.yield)"
            recipeCookTimeLabel.text = "\(recipe.totalTime) min"
            
            RecipeController.fetchImage(for: recipe) { (result) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.recipeImageView.image = image
                    }
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
    }
}
